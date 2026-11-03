import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../domain/exercise.dart';

part 'exercise_repository.g.dart';

/// Gym-wide library settings: the equipment the gym has and an optional
/// base URL for the seeded images.
class TrainingSettings {
  const TrainingSettings({required this.equipment, this.imageBase});

  factory TrainingSettings.fromJson(Map<String, dynamic> j) => TrainingSettings(
    equipment: {for (final e in (j['equipment'] as List<dynamic>? ?? kEquipment)) e as String},
    imageBase: j['image_base'] as String?,
  );

  final Set<String> equipment;
  final String? imageBase;

  Map<String, dynamic> toJson() => {'equipment': equipment.toList(), 'image_base': imageBase};
}

abstract interface class ExerciseRepository {
  /// The whole catalogue: the saved copy, updated with whatever changed on
  /// the server since (4.1, "opens offline after first sync").
  Future<List<Exercise>> catalogue();

  Future<Set<String>> favourites();
  Future<void> setFavourite(String exerciseId, {required bool on});
  Future<TrainingSettings> trainingSettings();
  Future<void> saveEquipment(Set<String> equipment);

  /// Creates or updates a custom exercise; returns its id.
  Future<String> saveCustom(ExerciseDraft draft, {Uint8List? photo});
  Future<void> archive(String id);
}

/// Where the catalogue is kept between launches.
abstract interface class CatalogueStore {
  Future<({DateTime? syncedAt, List<Map<String, dynamic>> rows})?> read();
  Future<void> write(DateTime syncedAt, List<Map<String, dynamic>> rows);
}

/// A JSON file in the app's support folder (phones, desktop).
class FileCatalogueStore implements CatalogueStore {
  Future<File> _file() async => File('${(await getApplicationSupportDirectory()).path}/exercise_catalogue_v1.json');

  @override
  Future<({DateTime? syncedAt, List<Map<String, dynamic>> rows})?> read() async {
    try {
      final f = await _file();
      if (!f.existsSync()) return null;
      return _decode(await f.readAsString());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(DateTime syncedAt, List<Map<String, dynamic>> rows) async {
    final f = await _file();
    await f.writeAsString(_encode(syncedAt, rows), flush: true);
  }
}

/// Browser storage (web).
class PrefsCatalogueStore implements CatalogueStore {
  PrefsCatalogueStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'exercise_catalogue_v1';

  @override
  Future<({DateTime? syncedAt, List<Map<String, dynamic>> rows})?> read() async {
    final raw = _prefs.getString(_key);
    return raw == null ? null : _decode(raw);
  }

  @override
  Future<void> write(DateTime syncedAt, List<Map<String, dynamic>> rows) =>
      _prefs.setString(_key, _encode(syncedAt, rows));
}

String _encode(DateTime syncedAt, List<Map<String, dynamic>> rows) =>
    jsonEncode({'synced_at': syncedAt.toIso8601String(), 'rows': rows});

({DateTime? syncedAt, List<Map<String, dynamic>> rows})? _decode(String raw) {
  try {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return (
      syncedAt: DateTime.tryParse(j['synced_at'] as String? ?? ''),
      rows: (j['rows'] as List<dynamic>).cast<Map<String, dynamic>>(),
    );
  } catch (_) {
    return null;
  }
}

bool _isOffline(Object e) {
  final t = e.toString();
  return e is TimeoutException || t.contains('SocketException') || t.contains('ClientException') || e is NetworkFailure;
}

class SupabaseExerciseRepository implements ExerciseRepository {
  SupabaseExerciseRepository(this._db, this._store, this._prefs);

  final SupabaseClient _db;
  final CatalogueStore _store;
  final SharedPreferences _prefs;

  static const _cols =
      'id, source_id, name, local_name, primary_muscles, secondary_muscles, equipment, level, category, mechanic, '
      'force, tracking_type, instructions, tips, mistakes, images, video_url, is_custom, created_by, updated_at, archived_at';
  static const _favKey = 'favourite_exercises';
  static const _settingsKey = 'training_settings';

  @override
  Future<List<Exercise>> catalogue() async {
    final cached = await _store.read();
    final byId = {for (final r in cached?.rows ?? const <Map<String, dynamic>>[]) r['id'] as String: r};
    try {
      final since = cached?.syncedAt;
      var syncedAt = since ?? DateTime.utc(2000);
      const page = 1000;
      for (var offset = 0; ; offset += page) {
        var q = _db.from('exercises').select(_cols);
        if (since != null) q = q.gte('updated_at', since.toIso8601String());
        final rows = await q.order('updated_at').order('id').range(offset, offset + page - 1);
        for (final r in rows) {
          byId[r['id'] as String] = r;
          final t = DateTime.parse(r['updated_at'] as String);
          if (t.isAfter(syncedAt)) syncedAt = t;
        }
        if (rows.length < page) break;
      }
      await _store.write(syncedAt, byId.values.toList());
    } catch (e) {
      // Offline (or the server hiccuped) with a saved copy: use it.
      if (byId.isEmpty) throw _isOffline(e) ? const NetworkFailure() : ServerFailure(e.toString());
    }
    return [for (final r in byId.values) Exercise.fromJson(r)];
  }

  @override
  Future<Set<String>> favourites() async {
    try {
      final rows = await _db.from('favourite_exercises').select('exercise_id');
      final ids = {for (final r in rows) r['exercise_id'] as String};
      await _prefs.setStringList(_favKey, ids.toList());
      return ids;
    } catch (e) {
      if (_isOffline(e)) return {...?_prefs.getStringList(_favKey)};
      rethrow;
    }
  }

  @override
  Future<void> setFavourite(String exerciseId, {required bool on}) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw const NotAllowedFailure();
    try {
      if (on) {
        await _db.from('favourite_exercises').upsert({'user_id': uid, 'exercise_id': exerciseId});
      } else {
        await _db.from('favourite_exercises').delete().eq('user_id', uid).eq('exercise_id', exerciseId);
      }
      final ids = {...?_prefs.getStringList(_favKey)};
      on ? ids.add(exerciseId) : ids.remove(exerciseId);
      await _prefs.setStringList(_favKey, ids.toList());
    } catch (e) {
      if (_isOffline(e)) throw const NetworkFailure();
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TrainingSettings> trainingSettings() async {
    try {
      final res = await _db.rpc<Map<String, dynamic>>('training_settings');
      final s = TrainingSettings.fromJson(res);
      await _prefs.setString(_settingsKey, jsonEncode(s.toJson()));
      return s;
    } catch (e) {
      final raw = _prefs.getString(_settingsKey);
      if (raw != null) return TrainingSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      return const TrainingSettings(equipment: {...kEquipment});
    }
  }

  @override
  Future<void> saveEquipment(Set<String> equipment) async {
    try {
      final saved = await _db
          .from('settings')
          .upsert({'key': 'gym_equipment', 'value': equipment.toList()})
          .select('key');
      if (saved.isEmpty) throw const NotAllowedFailure();
    } on PostgrestException catch (e) {
      if (e.code == '42501') throw const NotAllowedFailure();
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<String> saveCustom(ExerciseDraft draft, {Uint8List? photo}) async {
    try {
      final json = draft.toJson();
      String id;
      if (draft.id == null) {
        final row = await _db.from('exercises').insert(json).select('id').single();
        id = row['id'] as String;
      } else {
        id = draft.id!;
        final rows = await _db.from('exercises').update(json).eq('id', id).select('id');
        if (rows.isEmpty) throw const NotAllowedFailure();
      }
      if (photo != null) {
        final path = 'custom/$id/0.jpg';
        await _db.storage
            .from('exercises')
            .uploadBinary(path, photo, fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true));
        await _db
            .from('exercises')
            .update({
              'images': [path],
            })
            .eq('id', id);
      }
      return id;
    } on AppFailure {
      rethrow;
    } on PostgrestException catch (e) {
      if (e.code == '42501') throw const NotAllowedFailure();
      if (e.code == '23514') throw RuleFailure(e.message);
      throw ServerFailure(e.message);
    } catch (e) {
      if (_isOffline(e)) throw const NetworkFailure();
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> archive(String id) async {
    try {
      final rows = await _db
          .from('exercises')
          .update({'archived_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', id)
          .select('id');
      if (rows.isEmpty) throw const NotAllowedFailure();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}

@Riverpod(keepAlive: true)
ExerciseRepository exerciseRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  final prefs = ref.watch(sharedPreferencesProvider);
  return SupabaseExerciseRepository(client, kIsWeb ? PrefsCatalogueStore(prefs) : FileCatalogueStore(), prefs);
}

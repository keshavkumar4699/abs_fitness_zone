// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_reminders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealReminders)
final mealRemindersProvider = MealRemindersProvider._();

final class MealRemindersProvider extends $FunctionalProvider<MealReminders, MealReminders, MealReminders>
    with $Provider<MealReminders> {
  MealRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealRemindersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealRemindersHash();

  @$internal
  @override
  $ProviderElement<MealReminders> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MealReminders create(Ref ref) {
    return mealReminders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealReminders value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MealReminders>(value));
  }
}

String _$mealRemindersHash() => r'60511e24155ce45dd53a6b13866002fa64e1ea99';

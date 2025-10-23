// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'chip_state_provider.dart';

// // **************************************************************************
// // RiverpodGenerator
// // **************************************************************************

// String _$chipStateNotifierHash() => r'9a082ffa39c4ece6b87d3c527a0ec1604dbac835';

// /// Copied from Dart SDK
// class _SystemHash {
//   _SystemHash._();

//   static int combine(int hash, int value) {
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + value);
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
//     return hash ^ (hash >> 6);
//   }

//   static int finish(int hash) {
//     // ignore: parameter_assignments
//     hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
//     // ignore: parameter_assignments
//     hash = hash ^ (hash >> 11);
//     return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
//   }
// }

// abstract class _$ChipStateNotifier
//     extends BuildlessAutoDisposeAsyncNotifier<ChipState> {
//   late final Map<String, dynamic> body;

//   FutureOr<ChipState> build(Map<String, dynamic> body);
// }

// /// See also [ChipStateNotifier].
// @ProviderFor(ChipStateNotifier)
// const chipStateNotifierProvider = ChipStateNotifierFamily();

// /// See also [ChipStateNotifier].
// class ChipStateNotifierFamily extends Family<AsyncValue<ChipState>> {
//   /// See also [ChipStateNotifier].
//   const ChipStateNotifierFamily();

//   /// See also [ChipStateNotifier].
//   ChipStateNotifierProvider call(Map<String, dynamic> body) {
//     return ChipStateNotifierProvider(body);
//   }

//   @override
//   ChipStateNotifierProvider getProviderOverride(
//     covariant ChipStateNotifierProvider provider,
//   ) {
//     return call(provider.body);
//   }

//   static const Iterable<ProviderOrFamily>? _dependencies = null;

//   @override
//   Iterable<ProviderOrFamily>? get dependencies => _dependencies;

//   static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

//   @override
//   Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
//       _allTransitiveDependencies;

//   @override
//   String? get name => r'chipStateNotifierProvider';
// }

// /// See also [ChipStateNotifier].
// class ChipStateNotifierProvider
//     extends AutoDisposeAsyncNotifierProviderImpl<ChipStateNotifier, ChipState> {
//   /// See also [ChipStateNotifier].
//   ChipStateNotifierProvider(Map<String, dynamic> body)
//     : this._internal(
//         () => ChipStateNotifier()..body = body,
//         from: chipStateNotifierProvider,
//         name: r'chipStateNotifierProvider',
//         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
//             ? null
//             : _$chipStateNotifierHash,
//         dependencies: ChipStateNotifierFamily._dependencies,
//         allTransitiveDependencies:
//             ChipStateNotifierFamily._allTransitiveDependencies,
//         body: body,
//       );

//   ChipStateNotifierProvider._internal(
//     super._createNotifier, {
//     required super.name,
//     required super.dependencies,
//     required super.allTransitiveDependencies,
//     required super.debugGetCreateSourceHash,
//     required super.from,
//     required this.body,
//   }) : super.internal();

//   final Map<String, dynamic> body;

//   @override
//   FutureOr<ChipState> runNotifierBuild(covariant ChipStateNotifier notifier) {
//     return notifier.build(body);
//   }

//   @override
//   Override overrideWith(ChipStateNotifier Function() create) {
//     return ProviderOverride(
//       origin: this,
//       override: ChipStateNotifierProvider._internal(
//         () => create()..body = body,
//         from: from,
//         name: null,
//         dependencies: null,
//         allTransitiveDependencies: null,
//         debugGetCreateSourceHash: null,
//         body: body,
//       ),
//     );
//   }

//   @override
//   AutoDisposeAsyncNotifierProviderElement<ChipStateNotifier, ChipState>
//   createElement() {
//     return _ChipStateNotifierProviderElement(this);
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is ChipStateNotifierProvider && other.body == body;
//   }

//   @override
//   int get hashCode {
//     var hash = _SystemHash.combine(0, runtimeType.hashCode);
//     hash = _SystemHash.combine(hash, body.hashCode);

//     return _SystemHash.finish(hash);
//   }
// }

// @Deprecated('Will be removed in 3.0. Use Ref instead')
// // ignore: unused_element
// mixin ChipStateNotifierRef on AutoDisposeAsyncNotifierProviderRef<ChipState> {
//   /// The parameter `body` of this provider.
//   Map<String, dynamic> get body;
// }

// class _ChipStateNotifierProviderElement
//     extends
//         AutoDisposeAsyncNotifierProviderElement<ChipStateNotifier, ChipState>
//     with ChipStateNotifierRef {
//   _ChipStateNotifierProviderElement(super.provider);

//   @override
//   Map<String, dynamic> get body => (origin as ChipStateNotifierProvider).body;
// }

// // ignore_for_file: type=lint
// // ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

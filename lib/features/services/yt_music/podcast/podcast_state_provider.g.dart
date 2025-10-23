// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'podcast_state_provider.dart';

// // **************************************************************************
// // RiverpodGenerator
// // **************************************************************************

// String _$podcastStateNotifierHash() =>
//     r'00456e4939daae59413f6520cf96c21f548d0e6e';

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

// abstract class _$PodcastStateNotifier
//     extends BuildlessAutoDisposeAsyncNotifier<PodcastState> {
//   late final Map<String, dynamic> body;

//   FutureOr<PodcastState> build(Map<String, dynamic> body);
// }

// /// See also [PodcastStateNotifier].
// @ProviderFor(PodcastStateNotifier)
// const podcastStateNotifierProvider = PodcastStateNotifierFamily();

// /// See also [PodcastStateNotifier].
// class PodcastStateNotifierFamily extends Family<AsyncValue<PodcastState>> {
//   /// See also [PodcastStateNotifier].
//   const PodcastStateNotifierFamily();

//   /// See also [PodcastStateNotifier].
//   PodcastStateNotifierProvider call(Map<String, dynamic> body) {
//     return PodcastStateNotifierProvider(body);
//   }

//   @override
//   PodcastStateNotifierProvider getProviderOverride(
//     covariant PodcastStateNotifierProvider provider,
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
//   String? get name => r'podcastStateNotifierProvider';
// }

// /// See also [PodcastStateNotifier].
// class PodcastStateNotifierProvider
//     extends
//         AutoDisposeAsyncNotifierProviderImpl<
//           PodcastStateNotifier,
//           PodcastState
//         > {
//   /// See also [PodcastStateNotifier].
//   PodcastStateNotifierProvider(Map<String, dynamic> body)
//     : this._internal(
//         () => PodcastStateNotifier()..body = body,
//         from: podcastStateNotifierProvider,
//         name: r'podcastStateNotifierProvider',
//         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
//             ? null
//             : _$podcastStateNotifierHash,
//         dependencies: PodcastStateNotifierFamily._dependencies,
//         allTransitiveDependencies:
//             PodcastStateNotifierFamily._allTransitiveDependencies,
//         body: body,
//       );

//   PodcastStateNotifierProvider._internal(
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
//   FutureOr<PodcastState> runNotifierBuild(
//     covariant PodcastStateNotifier notifier,
//   ) {
//     return notifier.build(body);
//   }

//   @override
//   Override overrideWith(PodcastStateNotifier Function() create) {
//     return ProviderOverride(
//       origin: this,
//       override: PodcastStateNotifierProvider._internal(
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
//   AutoDisposeAsyncNotifierProviderElement<PodcastStateNotifier, PodcastState>
//   createElement() {
//     return _PodcastStateNotifierProviderElement(this);
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is PodcastStateNotifierProvider && other.body == body;
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
// mixin PodcastStateNotifierRef
//     on AutoDisposeAsyncNotifierProviderRef<PodcastState> {
//   /// The parameter `body` of this provider.
//   Map<String, dynamic> get body;
// }

// class _PodcastStateNotifierProviderElement
//     extends
//         AutoDisposeAsyncNotifierProviderElement<
//           PodcastStateNotifier,
//           PodcastState
//         >
//     with PodcastStateNotifierRef {
//   _PodcastStateNotifierProviderElement(super.provider);

//   @override
//   Map<String, dynamic> get body =>
//       (origin as PodcastStateNotifierProvider).body;
// }

// // ignore_for_file: type=lint
// // ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

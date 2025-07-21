// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$artistStateNotifierHash() =>
    r'17a90c75bec2d316e973c89f91d7dac7f769b357';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ArtistStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ArtistState> {
  late final Map<String, dynamic> body;

  FutureOr<ArtistState> build(Map<String, dynamic> body);
}

/// See also [ArtistStateNotifier].
@ProviderFor(ArtistStateNotifier)
const artistStateNotifierProvider = ArtistStateNotifierFamily();

/// See also [ArtistStateNotifier].
class ArtistStateNotifierFamily extends Family<AsyncValue<ArtistState>> {
  /// See also [ArtistStateNotifier].
  const ArtistStateNotifierFamily();

  /// See also [ArtistStateNotifier].
  ArtistStateNotifierProvider call(Map<String, dynamic> body) {
    return ArtistStateNotifierProvider(body);
  }

  @override
  ArtistStateNotifierProvider getProviderOverride(
    covariant ArtistStateNotifierProvider provider,
  ) {
    return call(provider.body);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'artistStateNotifierProvider';
}

/// See also [ArtistStateNotifier].
class ArtistStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ArtistStateNotifier, ArtistState> {
  /// See also [ArtistStateNotifier].
  ArtistStateNotifierProvider(Map<String, dynamic> body)
    : this._internal(
        () => ArtistStateNotifier()..body = body,
        from: artistStateNotifierProvider,
        name: r'artistStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$artistStateNotifierHash,
        dependencies: ArtistStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            ArtistStateNotifierFamily._allTransitiveDependencies,
        body: body,
      );

  ArtistStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.body,
  }) : super.internal();

  final Map<String, dynamic> body;

  @override
  FutureOr<ArtistState> runNotifierBuild(
    covariant ArtistStateNotifier notifier,
  ) {
    return notifier.build(body);
  }

  @override
  Override overrideWith(ArtistStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ArtistStateNotifierProvider._internal(
        () => create()..body = body,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        body: body,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ArtistStateNotifier, ArtistState>
  createElement() {
    return _ArtistStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistStateNotifierProvider && other.body == body;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, body.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArtistStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ArtistState> {
  /// The parameter `body` of this provider.
  Map<String, dynamic> get body;
}

class _ArtistStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ArtistStateNotifier,
          ArtistState
        >
    with ArtistStateNotifierRef {
  _ArtistStateNotifierProviderElement(super.provider);

  @override
  Map<String, dynamic> get body => (origin as ArtistStateNotifierProvider).body;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$albumStateNotifierHash() =>
    r'7adb71a60b39abe09c3a52dfc4cfee08b5d8ac50';

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

abstract class _$AlbumStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<AlbumState> {
  late final Map<String, dynamic> body;

  FutureOr<AlbumState> build(Map<String, dynamic> body);
}

/// See also [AlbumStateNotifier].
@ProviderFor(AlbumStateNotifier)
const albumStateNotifierProvider = AlbumStateNotifierFamily();

/// See also [AlbumStateNotifier].
class AlbumStateNotifierFamily extends Family<AsyncValue<AlbumState>> {
  /// See also [AlbumStateNotifier].
  const AlbumStateNotifierFamily();

  /// See also [AlbumStateNotifier].
  AlbumStateNotifierProvider call(Map<String, dynamic> body) {
    return AlbumStateNotifierProvider(body);
  }

  @override
  AlbumStateNotifierProvider getProviderOverride(
    covariant AlbumStateNotifierProvider provider,
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
  String? get name => r'albumStateNotifierProvider';
}

/// See also [AlbumStateNotifier].
class AlbumStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<AlbumStateNotifier, AlbumState> {
  /// See also [AlbumStateNotifier].
  AlbumStateNotifierProvider(Map<String, dynamic> body)
    : this._internal(
        () => AlbumStateNotifier()..body = body,
        from: albumStateNotifierProvider,
        name: r'albumStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$albumStateNotifierHash,
        dependencies: AlbumStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            AlbumStateNotifierFamily._allTransitiveDependencies,
        body: body,
      );

  AlbumStateNotifierProvider._internal(
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
  FutureOr<AlbumState> runNotifierBuild(covariant AlbumStateNotifier notifier) {
    return notifier.build(body);
  }

  @override
  Override overrideWith(AlbumStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AlbumStateNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<AlbumStateNotifier, AlbumState>
  createElement() {
    return _AlbumStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumStateNotifierProvider && other.body == body;
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
mixin AlbumStateNotifierRef on AutoDisposeAsyncNotifierProviderRef<AlbumState> {
  /// The parameter `body` of this provider.
  Map<String, dynamic> get body;
}

class _AlbumStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<AlbumStateNotifier, AlbumState>
    with AlbumStateNotifierRef {
  _AlbumStateNotifierProviderElement(super.provider);

  @override
  Map<String, dynamic> get body => (origin as AlbumStateNotifierProvider).body;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

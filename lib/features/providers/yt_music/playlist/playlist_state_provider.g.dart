// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistStateNotifierHash() =>
    r'365ee7d4aa3ea5e9e01649e705541f01a421ef22';

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

abstract class _$PlaylistStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<PlaylistState> {
  late final Map<String, dynamic> body;

  FutureOr<PlaylistState> build(Map<String, dynamic> body);
}

/// See also [PlaylistStateNotifier].
@ProviderFor(PlaylistStateNotifier)
const playlistStateNotifierProvider = PlaylistStateNotifierFamily();

/// See also [PlaylistStateNotifier].
class PlaylistStateNotifierFamily extends Family<AsyncValue<PlaylistState>> {
  /// See also [PlaylistStateNotifier].
  const PlaylistStateNotifierFamily();

  /// See also [PlaylistStateNotifier].
  PlaylistStateNotifierProvider call(Map<String, dynamic> body) {
    return PlaylistStateNotifierProvider(body);
  }

  @override
  PlaylistStateNotifierProvider getProviderOverride(
    covariant PlaylistStateNotifierProvider provider,
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
  String? get name => r'playlistStateNotifierProvider';
}

/// See also [PlaylistStateNotifier].
class PlaylistStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PlaylistStateNotifier,
          PlaylistState
        > {
  /// See also [PlaylistStateNotifier].
  PlaylistStateNotifierProvider(Map<String, dynamic> body)
    : this._internal(
        () => PlaylistStateNotifier()..body = body,
        from: playlistStateNotifierProvider,
        name: r'playlistStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playlistStateNotifierHash,
        dependencies: PlaylistStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            PlaylistStateNotifierFamily._allTransitiveDependencies,
        body: body,
      );

  PlaylistStateNotifierProvider._internal(
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
  FutureOr<PlaylistState> runNotifierBuild(
    covariant PlaylistStateNotifier notifier,
  ) {
    return notifier.build(body);
  }

  @override
  Override overrideWith(PlaylistStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlaylistStateNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PlaylistStateNotifier, PlaylistState>
  createElement() {
    return _PlaylistStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistStateNotifierProvider && other.body == body;
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
mixin PlaylistStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<PlaylistState> {
  /// The parameter `body` of this provider.
  Map<String, dynamic> get body;
}

class _PlaylistStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PlaylistStateNotifier,
          PlaylistState
        >
    with PlaylistStateNotifierRef {
  _PlaylistStateNotifierProviderElement(super.provider);

  @override
  Map<String, dynamic> get body =>
      (origin as PlaylistStateNotifierProvider).body;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

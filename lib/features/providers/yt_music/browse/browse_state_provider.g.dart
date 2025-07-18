// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$browseStateNotifierHash() =>
    r'c7bd4cc41c54c293f6aefb88a2461dcfe761b156';

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

abstract class _$BrowseStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<YTBrowsePage> {
  late final Map<String, dynamic> body;

  FutureOr<YTBrowsePage> build(Map<String, dynamic> body);
}

/// See also [BrowseStateNotifier].
@ProviderFor(BrowseStateNotifier)
const browseStateNotifierProvider = BrowseStateNotifierFamily();

/// See also [BrowseStateNotifier].
class BrowseStateNotifierFamily extends Family<AsyncValue<YTBrowsePage>> {
  /// See also [BrowseStateNotifier].
  const BrowseStateNotifierFamily();

  /// See also [BrowseStateNotifier].
  BrowseStateNotifierProvider call(Map<String, dynamic> body) {
    return BrowseStateNotifierProvider(body);
  }

  @override
  BrowseStateNotifierProvider getProviderOverride(
    covariant BrowseStateNotifierProvider provider,
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
  String? get name => r'browseStateNotifierProvider';
}

/// See also [BrowseStateNotifier].
class BrowseStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BrowseStateNotifier,
          YTBrowsePage
        > {
  /// See also [BrowseStateNotifier].
  BrowseStateNotifierProvider(Map<String, dynamic> body)
    : this._internal(
        () => BrowseStateNotifier()..body = body,
        from: browseStateNotifierProvider,
        name: r'browseStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$browseStateNotifierHash,
        dependencies: BrowseStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            BrowseStateNotifierFamily._allTransitiveDependencies,
        body: body,
      );

  BrowseStateNotifierProvider._internal(
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
  FutureOr<YTBrowsePage> runNotifierBuild(
    covariant BrowseStateNotifier notifier,
  ) {
    return notifier.build(body);
  }

  @override
  Override overrideWith(BrowseStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BrowseStateNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<BrowseStateNotifier, YTBrowsePage>
  createElement() {
    return _BrowseStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BrowseStateNotifierProvider && other.body == body;
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
mixin BrowseStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<YTBrowsePage> {
  /// The parameter `body` of this provider.
  Map<String, dynamic> get body;
}

class _BrowseStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BrowseStateNotifier,
          YTBrowsePage
        >
    with BrowseStateNotifierRef {
  _BrowseStateNotifierProviderElement(super.provider);

  @override
  Map<String, dynamic> get body => (origin as BrowseStateNotifierProvider).body;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

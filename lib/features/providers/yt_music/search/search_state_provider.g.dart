// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getSuggestionsHash() => r'49214f4913ee7c8adaca8fe54d04b1b22731ff39';

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

/// See also [getSuggestions].
@ProviderFor(getSuggestions)
const getSuggestionsProvider = GetSuggestionsFamily();

/// See also [getSuggestions].
class GetSuggestionsFamily extends Family<AsyncValue<YTSearchSuggestions>> {
  /// See also [getSuggestions].
  const GetSuggestionsFamily();

  /// See also [getSuggestions].
  GetSuggestionsProvider call(String query) {
    return GetSuggestionsProvider(query);
  }

  @override
  GetSuggestionsProvider getProviderOverride(
    covariant GetSuggestionsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getSuggestionsProvider';
}

/// See also [getSuggestions].
class GetSuggestionsProvider
    extends AutoDisposeFutureProvider<YTSearchSuggestions> {
  /// See also [getSuggestions].
  GetSuggestionsProvider(String query)
    : this._internal(
        (ref) => getSuggestions(ref as GetSuggestionsRef, query),
        from: getSuggestionsProvider,
        name: r'getSuggestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getSuggestionsHash,
        dependencies: GetSuggestionsFamily._dependencies,
        allTransitiveDependencies:
            GetSuggestionsFamily._allTransitiveDependencies,
        query: query,
      );

  GetSuggestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<YTSearchSuggestions> Function(GetSuggestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSuggestionsProvider._internal(
        (ref) => create(ref as GetSuggestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<YTSearchSuggestions> createElement() {
    return _GetSuggestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSuggestionsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSuggestionsRef on AutoDisposeFutureProviderRef<YTSearchSuggestions> {
  /// The parameter `query` of this provider.
  String get query;
}

class _GetSuggestionsProviderElement
    extends AutoDisposeFutureProviderElement<YTSearchSuggestions>
    with GetSuggestionsRef {
  _GetSuggestionsProviderElement(super.provider);

  @override
  String get query => (origin as GetSuggestionsProvider).query;
}

String _$searchStateNotifierHash() =>
    r'b20cc9b76c73e17512620ae17ecf201a4a4066dc';

abstract class _$SearchStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SearchState> {
  late final String query;

  FutureOr<SearchState> build(String query);
}

/// See also [SearchStateNotifier].
@ProviderFor(SearchStateNotifier)
const searchStateNotifierProvider = SearchStateNotifierFamily();

/// See also [SearchStateNotifier].
class SearchStateNotifierFamily extends Family<AsyncValue<SearchState>> {
  /// See also [SearchStateNotifier].
  const SearchStateNotifierFamily();

  /// See also [SearchStateNotifier].
  SearchStateNotifierProvider call(String query) {
    return SearchStateNotifierProvider(query);
  }

  @override
  SearchStateNotifierProvider getProviderOverride(
    covariant SearchStateNotifierProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchStateNotifierProvider';
}

/// See also [SearchStateNotifier].
class SearchStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<SearchStateNotifier, SearchState> {
  /// See also [SearchStateNotifier].
  SearchStateNotifierProvider(String query)
    : this._internal(
        () => SearchStateNotifier()..query = query,
        from: searchStateNotifierProvider,
        name: r'searchStateNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchStateNotifierHash,
        dependencies: SearchStateNotifierFamily._dependencies,
        allTransitiveDependencies:
            SearchStateNotifierFamily._allTransitiveDependencies,
        query: query,
      );

  SearchStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<SearchState> runNotifierBuild(
    covariant SearchStateNotifier notifier,
  ) {
    return notifier.build(query);
  }

  @override
  Override overrideWith(SearchStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchStateNotifierProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchStateNotifier, SearchState>
  createElement() {
    return _SearchStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchStateNotifierProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SearchState> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SearchStateNotifier,
          SearchState
        >
    with SearchStateNotifierRef {
  _SearchStateNotifierProviderElement(super.provider);

  @override
  String get query => (origin as SearchStateNotifierProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

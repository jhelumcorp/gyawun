class Stack<T> {
  final _list = <T>[];

  void push(T value) => _list.add(value);
  void pushFirst(T value) => _list.insert(0, value);
  T pop() => _list.removeLast();
  T get top => _list.last;
  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  int get length => _list.length;
}

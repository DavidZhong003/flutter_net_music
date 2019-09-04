///容量限制的栈
class FixedStackStorage<E> {
  final List<E> _stack;
  final int capacity;
  int _top;

  FixedStackStorage(this.capacity)
      : assert(capacity >= 0),
        _top = -1,
        _stack = List<E>(capacity);

  bool get isEmpty => _top == -1;

  bool get isFull => _top == capacity - 1;

  int get size => _top + 1;

  void push(E e) {
    if (isFull) throw StackOverflowError;
    _stack[++_top] = e;
  }

  E pop() {
    if (isEmpty) throw StacksEmptyException;
    return _stack[_top--];
  }

  E get top {
    if (isEmpty) throw StacksEmptyException;
    return _stack[_top];
  }
}

class StackStorage<E> {
  final List<E> _stack;

  int _top;

  StackStorage()
      : _stack = List<E>(),
        _top = -1;

  bool get isEmpty => _top == -1;

  int get size => _top + 1;

  void push(E e) {
    _stack[++_top] = e;
  }

  E pop() {
    return isEmpty ? null : _stack[_top--];
  }

  E get top {
    return isEmpty ? null : _stack[_top];
  }
}

mixin StacksEmptyException implements Exception {}

class LinkNode<E> {
  final E e;

  LinkNode<E> next;

  LinkNode<E> pre;

  LinkNode(this.e);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookmarkStore on _BookmarkStore, Store {
  late final _$mBookmarkAtom =
      Atom(name: '_BookmarkStore.mBookmark', context: context);

  @override
  ObservableList<PostModel> get mBookmark {
    _$mBookmarkAtom.reportRead();
    return super.mBookmark;
  }

  @override
  set mBookmark(ObservableList<PostModel> value) {
    _$mBookmarkAtom.reportWrite(value, super.mBookmark, () {
      super.mBookmark = value;
    });
  }

  late final _$addToWishListAsyncAction =
      AsyncAction('_BookmarkStore.addToWishList', context: context);

  @override
  Future<void> addToWishList(PostModel postModel) {
    return _$addToWishListAsyncAction.run(() => super.addToWishList(postModel));
  }

  late final _$storeBookmarkDataAsyncAction =
      AsyncAction('_BookmarkStore.storeBookmarkData', context: context);

  @override
  Future<void> storeBookmarkData() {
    return _$storeBookmarkDataAsyncAction.run(() => super.storeBookmarkData());
  }

  late final _$clearBookmarkAsyncAction =
      AsyncAction('_BookmarkStore.clearBookmark', context: context);

  @override
  Future<void> clearBookmark() {
    return _$clearBookmarkAsyncAction.run(() => super.clearBookmark());
  }

  late final _$getBookMarkListAsyncAction =
      AsyncAction('_BookmarkStore.getBookMarkList', context: context);

  @override
  Future<void> getBookMarkList() {
    return _$getBookMarkListAsyncAction.run(() => super.getBookMarkList());
  }

  late final _$_BookmarkStoreActionController =
      ActionController(name: '_BookmarkStore', context: context);

  @override
  void addAllBookmark(List<PostModel> bookmarkList) {
    final _$actionInfo = _$_BookmarkStoreActionController.startAction(
        name: '_BookmarkStore.addAllBookmark');
    try {
      return super.addAllBookmark(bookmarkList);
    } finally {
      _$_BookmarkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mBookmark: ${mBookmark}
    ''';
  }
}

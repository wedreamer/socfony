import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fans/provider/collection.dart';

typedef Widget CloudBaseDocLoadingBuilder(BuildContext context);
typedef Widget CloudBaseDocErrorBuilder(BuildContext context, Object error);
typedef Widget CloudBaseDocChildBuilder<T>(BuildContext context, T value);
typedef void CloudBaseDocFetchedCallback<T>(T doc);

class CloudBaseDocBuilder<K, V, C extends BaseCollectionProvider<K, V>>
    extends StatelessWidget {
  final K id;
  final CloudBaseDocLoadingBuilder loadingBuilder;
  final CloudBaseDocChildBuilder<V> builder;
  final CloudBaseDocErrorBuilder errorBuilder;

  const CloudBaseDocBuilder({
    Key key,
    @required this.id,
    @required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.select<C, V>(_itemSelector);
    if (value is V) {
      return builder(context, value);
    }

    return FutureBuilder<V>(
      future: _createFuture(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingBuilder(context);
        } else if (snapshot.hasError) {
          return _errorBuilder(context, snapshot.error);
        } else if (!snapshot.hasData) {
          return _errorBuilder(context, UnsupportedError('Don\'t match doc'));
        }

        return builder(context, snapshot.data);
      },
    );
  }

  Widget _errorBuilder(BuildContext context, Object error) {
    return errorBuilder != null ? errorBuilder(context, error) : SizedBox();
  }

  Widget _loadingBuilder(BuildContext context) {
    return loadingBuilder != null ? loadingBuilder(context) : SizedBox();
  }

  V _itemSelector(C provider) => provider.containsKey(id) ? provider[id] : null;

  Future<V> _createFuture(BuildContext context) {
    return Provider.of<C>(context, listen: false).watchDoc(id);
  }
}

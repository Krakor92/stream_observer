import 'package:flutter/material.dart';

///
/// Class that use a StreamBuilder under the hood and reduce the boilerpate needed with AsyncSnapshot's states handling
///
class StreamObserver<T> extends StatelessWidget {
  final Stream<T>? stream;
  final Function(BuildContext, T) onData;

  final Function(BuildContext, Object?)? onError;
  Function(BuildContext, Object?) get _defaultOnError => (context, error) {
        return Center(
            child: Text(
          '$error',
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ));
      };

  final Function(BuildContext)? onWaiting;
  Function(BuildContext) get _defaultOnWaiting =>
      (context) => const Center(child: CircularProgressIndicator());

  final T? initialData;

  const StreamObserver(
      {Key? key,
      required this.stream,
      required this.onData,
      this.onError,
      this.onWaiting,
      this.initialData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError != null
              ? onError!(context, snapshot.error)
              : _defaultOnError(context, snapshot.error);
        }

        if (snapshot.hasData) {
          return onData(context, snapshot.data!);
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return onWaiting != null
                ? onWaiting!(context)
                : _defaultOnWaiting(context);

          default:
            return Container();
        }
      },
    );
  }
}

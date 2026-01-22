abstract class AsyncCommand<R> {
  Future<R> execute();
}

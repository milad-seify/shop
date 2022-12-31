void main(List<String> args) {
  Future myFuture = Future(() {
    return 'hello';
  });
  print('this runs first');
  myFuture.then((value) => print(value)).catchError((error) {
    //do somthing
  }).then((value) => print('after first then.we call chain'));
  print('this also runs before the future is done!');
  /*In a way, the synchronous code is executed first, then if the asynchronous code created by the future function is finished, the result will be given to us.   */
}

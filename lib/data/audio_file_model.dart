// class AudioFileModel extends ChangeNotifier {
//   final List<String> _list = [];

//   UnmodifiableListView<String> get items => UnmodifiableListView(_list);

//   int get totalPrice => _list.length;

//   void add(String item) {
//     _list.add(item);
//     notifyListeners();
//   }

//   void removeAll() {
//     _list.clear();
//     notifyListeners();
//   }
// }
class RecordedFile {
  String fileName = '';
  int timeStamp = 0;
  String tag = '';
  String mood = '';

  RecordedFile(this.fileName, this.timeStamp, this.tag, this.mood);
}

class AudioFiles {
  List<RecordedFile> fileList = [];

  void addFile(fileName, timeStamp, tag, mood) {
    fileList.add(RecordedFile(fileName, timeStamp, tag, mood));
    print(fileList.first.fileName);
  }
}

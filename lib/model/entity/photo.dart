import 'dart:io';

enum PhotoSource { File, Network }

class Photo {
  final String id;
  final String url;
  final File file;
  final PhotoSource source;

  Photo({this.id, this.url, this.file, this.source});

  Photo copyWith({String id, String url, File file, PhotoSource source}) {
    return Photo(
      id: id ?? this.id,
      url: url ?? this.url,
      file: file ?? this.file,
      source: source ?? this.source,
    );
  }
}

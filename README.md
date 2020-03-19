# file_picker_cross

Select files on Android, iOS, the desktop and the web.

## Getting Started

`file_picker_cross` allows you to select files from your device and is compatible with Android, iOS, Desktops (using go-flutter) and the web.

This package was realized using `file_picker`. We only added compatibility to the web.

```dart
FilePickerCross FilePickerCross(
    type: FileTypeCross.any,                        // Available: `any`, `audio`, `image`, `video`, `custom`
    fileExtension: ''                               // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp`
    );

Future<bool> pick()

String toString()

Uint8List toUint8List()

String toBase64()

MultipartFile toMultipartFile({String filename})

int get length
```

Example:
```dart
    FilePickerCross filePicker = FilePickerCross();
    filePicker.pick().then((value) => setState(() {
          _fileLength = filePicker.toUint8List().lengthInBytes;
          try {
            // Only works for text files.
            _fileString = filePicker.toString();
          } catch (e) {
            _fileString =
                'Not a text file. Showing base64.\n\n' + filePicker.toBase64();
          }
        }));
  }
```
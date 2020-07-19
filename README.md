# file_picker_cross

> The only Flutter plugin to select, open, choose or pick documents, images videos or other files on Android, iOS, the desktop and the web for reading, writing, use as String, byte list or HTTP uploads.

## Getting Started

`file_picker_cross` allows you to select files from your device and is compatible with Android, iOS, Desktops (using both go-flutter or FDE) and the web.

This package was realized using `file_picker` (Mobile platforms and go-flutter) and 'file_chooser' (Desktops). We only added compatibility to the web and mixed everything.

**Note:** *we recently had API changes. Please update your code accordingly.*
```dart
FilePickerCross FilePickerCross.pick(
    type: FileTypeCross.any,                        // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
    fileExtension: ''                               // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp`
    );

String toString()

Uint8List toUint8List()

String toBase64()

MultipartFile toMultipartFile({String filename})

int get length

String get path // BETA: not working properly using go-flutter
```

Example:
```dart
    FilePickerCross.pick().then((filePicker) => setState(() {
          _filePath = filePicker.path;
          _fileLength = filePicker.toUint8List().lengthInBytes;
          try {
            _fileString = filePicker.toString();
          } catch (e) {
            _fileString =
                'Not a text file. Showing base64.\n\n' + filePicker.toBase64();
          }
        }));
```

### What do go-flutter and FDE mean?

Flutter initially only supported Android and iOS. To add support for desktop platforms, some people started the [go-flutter](https://github.com/go-flutter-desktop/go-flutter) providing Flutter applications on Windows, Linux and macOS using the Go language.

Later, Flutter itself announced desktop support (FDE) but still, it's not stable yet.

We try to support both as much as possible.

### Web

Of cause, it requires Flutter to be set up for web development.

[Set up Flutter for Web](https://flutter.dev/web)

### All Desktop platforms

Of cause, it requires Flutter to be set up for your platform.

Please note, Windows is not officially supported by Google. Linux and macOS support is in alpha state. Expect issues and sometimes incompatible versions requiring manual hand work.

```
flutter channel dev # or master
flutter upgrade
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

#### More information

[Set up go-flutter](https://hover.build/) [Set up FDE](https://flutter.dev/desktop)

### Mobile platforms

*No setup required :tada:.*

### macOS (using FDE)

You will need to [add an
entitlement](https://github.com/google/flutter-desktop-embedding/blob/master/macOS-Security.md)
for either read-only access:
```
	<key>com.apple.security.files.user-selected.read-only</key>
	<true/>
```
or read/write access:
```
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
```
depending on your use case.

### Linux (using FDE)

This plugin requires the following libraries:

* GTK 3
* pkg-config

Installation example for Debian-based systems:

```shell
sudo apt-get install libgtk-3-dev pkg-config
```

Moreover, you will need to update `main.cc` to include [the GTK initialization and runloop changes
shown in the `testbed`
example](https://github.com/google/flutter-desktop-embedding/blob/master/testbed/linux/main.cc#L81-L91).

1. Delete your existing `linux` directory (make sure you know any manual modification you did): `rm -rf linux`
2. Copy the `linux` subdirectory of this projects's `example/` into your project.

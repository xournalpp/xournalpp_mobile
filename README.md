# <img src="assets/xournalpp-adaptive.png" width="64" style="height: auto;"/> Xournal++ - mobile edition (unofficial)

A port of the main features of Xournal++ to various Flutter platforms like Android, iOS and the Web.

# Try it out

***Update:** We can now render images and text!. You **won't see any
strokes** if you open a file but you **will see your images and texts**.* :tada:

This project is not yet ready for use. We are still implementing backend stuff like the handling of
the file format. As there is unfortunately [no full documentation](https://github.com/xournalpp/xournalpp/issues/2124)
of the `.xopp` format, you could describe this process als `try {...} catch (Exception e) {...}`.

https://theonewiththebraid.gitlab.io/xournalpp_mobile/

Alternatively, you can download pre-build binaries for **Linux** and **Android** from the GitLab pipeline.

### Visible parts already working:

- [x] Read the document title
- [x] Read and display the number of pages
- [x] Create thumbnails of the pages for the navigation bar
- [x] Smooth fade in after thumbnail rendering
- [x] Render images on the canvas
- [x] Render text on the canvas

## Getting started

Install Flutter first. See [flutter.dev](https://flutter.dev/docs/get-started/install) for more details.
```
# Run Flutter doctor to check whether the installation was successful
flutter doctor
```

Connect any Android or iOS device.

```
git clone https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile.git
cd xournalpp_mobile
flutter run
```

If you want to test for the web, please run:

```
flutter channel beta
flutter upgrade
flutter config --enable-web
flutter run -d web
```

If you want to test for Linux or macOS, please run:

```
flutter channel master
flutter upgrade
flutter config --enable-linux-desktop # or --enable-macos-desktop
flutter run -d linux # or macos
```

## Colors

Our primary color is the Material DeepPurple. I simply prefer a colorful application over an old-fashioned gray GTK+ application.

`#673ab7` / `rgb(103, 58, 183)` / `CMYK(44%, 68%, 0%, 28%)`, / `hsl(261°, 51%, 48%)`

## Legal notes

This project is licensed under the terms and conditions of the EUPL-1.2 found in [LICENSE](LICENSE).
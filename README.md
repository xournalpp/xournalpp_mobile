# <img src="assets/xournalpp-adaptive.png" width="64" style="height: auto;"/> Xournal++ Mobile

***Warning:*** *Xournal++ Mobile is currently in early development and **not** yet stable. Use with caution!*

[![Current version](https://img.shields.io/badge/dynamic/yaml?label=Current%20version&query=version&url=https%3A%2F%2Fgitlab.com%2FTheOneWithTheBraid%2Fxournalpp_mobile%2Fraw%2Fmaster%2Fpubspec.yaml%3Finline%3Dfalse&style=for-the-badge&logo=flutter&logoColor=white)](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/tags) [![Bitrise build](https://img.shields.io/bitrise/dd58f8fe5b4bf6c0?style=for-the-badge&token=Ihrbr8U0mqFlVBOocwtnQA&logo=bitrise&logoColor=white)](https://app.bitrise.io/app/dd58f8fe5b4bf6c0) [![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/TheOneWithTheBraid/xournalpp_mobile/master?style=for-the-badge&logo=gitlab&logoColor=white)](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/pipelines) [![Google Play](https://img.shields.io/endpoint?color=689f38&url=https%3A%2F%2Fplayshields.herokuapp.com%2Fplay%3Fi%3Donline.xournal.mobile%26l%3DGoogle-Play%26m%3D%24version&style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=online.xournal.mobile) [![Snap Store](https://img.shields.io/badge/Get%20it%20from%20the-Snap%20Store-%230e8620?style=for-the-badge&logo=snapcraft&logoColor=white)](https://snapcraft.io/xournalpp-mobile)

A port of the main features of Xournal++ to various Flutter platforms like Android, iOS and the Web.

![Feature banner](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/raw/master/assets/feature-banner.svg)

## Try it out

***Mission completed:** We can now render strokes, images and text and LaTeX!. We thereby support the full `.xopp` file format.* :tada:

- Web
  - [Open web app](https://xournal.online/)
  - [Access via TOR](http://xournaltdtf7ygqxg3qik4tdg476smkukogil74t6oxqiwdnumy53hqd.onion/)
- Android
  - [Download in Google Play](https://play.google.com/store/apps/details?id=online.xournal.mobile)
  - [Download APK](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/jobs/artifacts/master/browse?job=build%3Aapk)
- Windows
  - [Build for Windows](#desktop-support)
- Linux
  - [Download for Debian](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/jobs/artifacts/master/browse?job=build%3Adebian)
  - [Download for generic Linux](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/jobs/artifacts/master/download?job=build%3Alinux)
  - [Download from the Snap Store](https://snapcraft.io/xournalpp-mobile)

```shell
sudo snap install xournalpp-mobile
```

### Visible parts already working

- [x] Read the document title
- [x] Read and display the number of pages
- [x] Create thumbnails of the pages for the navigation bar
- [x] Smooth fade in after thumbnail rendering
- [x] Render images on the canvas
- [x] Render text on the canvas
- [x] Strokes
- [x] Highlighter
- [x] LaTeX
- [x] Recent files list
- [ ] Whiteout eraser
- [x] Saving
- [x] Basic editing
- [x] Basic PDF rendering

## Known issues

- **Immense memory consumption**: *If you open immense files, you get immense memory consumption. That's logic. Usually, Xournal++ Mobile takes twice the file size plus around 50MB for itself.*
- But **why** does it take twice the memory?: *No idea.*
- **The snap does not start on Linux when using wayland**: *Please set the environment variable `DISABLE_WAYLAND=1` before you start Xournal++ Mobile.*

## Getting started

### Prepare

> You would like to contribute? Please check out issues to solve [here](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/issues) or get our `// TODO:`s [here](https://gitlab.com/search?search=TODO&project_id=20056916)!

*The **GitHub** repository is only a mirrored repository. Please only contribute to the [original repository on **GitLab**](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile).*

Get your information about the `.xopp` file format at http://www-math.mit.edu/~auroux/software/xournal/manual.html#file-format .

Install Flutter first. See [flutter.dev](https://flutter.dev/docs/get-started/install) for more details.

```shell
# Run Flutter doctor to check whether the installation was successful
flutter doctor
```

### Get the sources and run

Connect any Android or iOS device.

```shell
git clone https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile.git
cd xournalpp_mobile
flutter run
```

### Test for the web

If you want to test for the web, please run:

```shell
flutter channel beta
flutter upgrade
flutter config --enable-web
flutter run -d web --release # unfortunately, the debug flavour will result an empty screen
```

### Desktop support

Linux is perfectly supported by Xournal++ Mobile and you can get prebuilt binaries [above](#try-it-out) or install from [Snap Store](https://snapcraft.io/xournalpp-mobile).

Windows is supported and tested too, but there are unfortunately no prebuilt binaries available. Execute the following commands to build them yourself.

If you want to test for Linux, Windows or macOS, please run:

```shell
flutter channel master
flutter upgrade
flutter config --enable-linux-desktop # or --enable-macos-desktop or --enable-windows-desktop
flutter run -d linux # or macos or windows
```

## Colors and Typography

### Colors

Our primary color is the Material DeepPurple. I simply prefer a colorful application over an old-fashioned gray GTK+ application.

`#673ab7` / `rgb(103, 58, 183)` / `CMYK(44%, 68%, 0%, 28%)` / `hsl(261°, 51%, 48%)`

The accent color is Material Pink.

`#e91e63` / `rgb(233, 30, 99)` / `CMYK(0%, 87%, 58%, 9%)`/ `hsl(340°, 81%, 51%)`

The light color is White.

`#ffffff` / `rgb(255, 255, 255)` / `CMYK(0%, 0%, 0%, 0%)`/ `hsl(0°, 0%, 100%)`

The dark color is Material Blue Grey 900.

`#263238` / `rgb(38, 50, 56)` / `CMYK(32%, 11%, 0%, 78%)`/ `hsl(200°, 19%, 18%)`

### Fonts

- Display Text: Open Sans Extra Bold *(800)* `Apache 2.0`, *accent color* or *light color*
- Title and Heading: Open Sans Regular *(400)* `Apache 2.0`, *light color*
- Emphasis: Glacial Indifference Regular *(400)* `SIL Open Font License`, *light color*, *UPPERCASE*
- Body: Open Sans Light *(300)* `Apache 2.0`, *light color*

## Misc

*Like this project? (Buy me a Coffee)[https://buymeacoff.ee/bbraid].*

This software is powered by the education software [TestApp](https://testapp.schule) — **Learning. Easily.**

[![TestApp banner](https://gitlab.com/testapp-system/testapp-flutter/-/raw/mobile/assets/Google%20Play%20EN.png)](https://testapp.schule)

## Legal notes

This project is licensed under the terms and conditions of the EUPL-1.2 found in [LICENSE](LICENSE).

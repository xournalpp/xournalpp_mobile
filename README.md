# <img src="assets/xournalpp-adaptive.png" width="64" style="height: auto;"/> Xournal++ - mobile edition (unofficial)

![Current version](https://img.shields.io/badge/dynamic/yaml?label=Current%20version&query=version&url=https%3A%2F%2Fgitlab.com%2FTheOneWithTheBraid%2Fxournalpp_mobile%2Fraw%2Fmaster%2Fpubspec.yaml%3Finline%3Dfalse&style=for-the-badge&logo=flutter&logoColor=white) ![Bitrise build](https://img.shields.io/bitrise/dd58f8fe5b4bf6c0?style=for-the-badge&token=Ihrbr8U0mqFlVBOocwtnQA&logo=bitrise&logoColor=white) ![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/TheOneWithTheBraid/xournalpp_mobile/master?style=for-the-badge&logo=gitlab&logoColor=white) ![Google Play](https://img.shields.io/endpoint?color=689f38&url=https%3A%2F%2Fplayshields.herokuapp.com%2Fplay%3Fi%3Donline.xournal.mobile%26l%3DGoogle-Play%26m%3D%24version&style=for-the-badge&logo=google-play&logoColor=white)]

A port of the main features of Xournal++ to various Flutter platforms like Android, iOS and the Web.

![feature banner](assets/feature-banner.svg)

# Try it out

***Mission completed:** We can now render strokes, images and text and LaTeX!. We thereby support the full `.xopp` file format.* :tada:

[Open web app](https://xournal.online/)

[Download in Google Play](https://play.google.com/store/apps/details?id=online.xournal.mobile)

[Download APK](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/jobs/artifacts/master/download?job=build%3Aapk)

[Download for Linux](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/jobs/artifacts/master/download?job=build%3Alinux)

### Visible parts already working:

- [x] Read the document title
- [x] Read and display the number of pages
- [x] Create thumbnails of the pages for the navigation bar
- [x] Smooth fade in after thumbnail rendering
- [x] Render images on the canvas
- [x] Render text on the canvas
- [x] Strokes
- [x] Highlighter
- [x] LaTeX
- [ ] Whiteout eraser
- [ ] Saving
- [ ] Basic editing

## Getting started

Get your information about the `.xopp` file format at http://www-math.mit.edu/~auroux/software/xournal/manual.html#file-format .

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

* Display Text: Open Sans Extra Bold *(800)* `Apache 2.0`, *accent color* or *light color*
* Title and Heading: Open Sans Regular *(400)* `Apache 2.0`, *light color*
* Emphasis: Glacial Indifference Regular *(400)* `SIL Open Font License`, *light color*, *UPPERCASE*
* Body: Open Sans Light *(300)* `Apache 2.0`, *light color*

# Misc

This software is powered by the education software [TestApp](https://testapp.schule) - **Learning. Easily.**

[![TestApp banner](https://gitlab.com/testapp-system/testapp-flutter/-/raw/mobile/assets/Google%20Play%20EN.png)](https://testapp.schule)

## Legal notes

This project is licensed under the terms and conditions of the EUPL-1.2 found in [LICENCE](LICENCE).
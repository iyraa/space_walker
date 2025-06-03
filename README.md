### README: Space Walker Project

---

## Overview

Space Walker is an interactive story-driven application built using Flutter. It combines dynamic dialogues, puzzles, and choices to create an immersive experience for the player.

This project was created as an assignment for Programming Applications & Programming course at the University of Portsmouth.

---

## Prerequisites

Before running the project, ensure you have the following installed:

### 1. **Flutter SDK**

- Download and install Flutter from [Flutter's official website](https://flutter.dev/docs/get-started/install).
- Verify installation by running:
  ```bash
  flutter doctor
  ```

### 2. **Dart SDK**

- Dart is included with Flutter, but ensure it's properly installed and configured.

### 3. **Dependencies**

- Install the required dependencies listed in pubspec.yaml:
  ```bash
  flutter pub get
  ```

### 4. **Hive Database**

- Hive is used for local storage. Ensure Hive is properly configured:
  - Hive boxes (`flags`, `nodes`) are initialized in the `FlagService` and `StoryService` classes.
  - Ensure the spacewalker.json file is correctly formatted and accessible.

### 5. **Audio Configuration**

- The project uses the `audioplayers` package for sound effects and background music.
- Ensure audio files are placed in the sfx directory.

### 6. **Assets**

- Background images, audio files, and other assets must be placed in the appropriate directories:
  - **Images**: Images
  - **Audio**: music & sfx
  - **JSON**: json

---

## Configuration

### 1. **pubspec.yaml**

Ensure the following configurations are present in pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.0.5
  hive_flutter: ^1.1.0
  animated_text_kit: ^4.2.2
  video_player: ^2.8.2
  audioplayers: ^6.4.0
  flutter_glow: ^0.3.0
  marquee: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.13

flutter:
     assets:
    - assets/json/spacewalker.json
    - assets/background/
    - assets/audio/
    - assets/audio/sfx/
    - assets/audio/music/

  fonts:
    - family: SpaceMono
      fonts:
        - asset: fonts/SpaceMono-Regular.ttf
        - asset: fonts/SpaceMono-Italic.ttf
          style: italic
        - asset: fonts/SpaceMono-Bold.ttf
          weight: 700
    - family: BrunoAceSC
      fonts:
        - asset: fonts/BrunoAceSC-Regular.ttf
    - family: Electrolize
      fonts:
        - asset: fonts/Electrolize-Regular.ttf
    - family: Rajdhani
      fonts:
        - asset: fonts/Rajdhani-Light.ttf
          weight: 300
        - asset: fonts/Rajdhani-Regular.ttf
        - asset: fonts/Rajdhani-Medium.ttf
          weight: 500
        - asset: fonts/Rajdhani-Bold.ttf
          weight: 700
```

### 2. **JSON File**

The `spacewalker.json` file contains the story nodes, dialogues, choices, and puzzles. Ensure the file is properly formatted and placed in the json directory.

### 3. **Audio Files**

Place all sound effects and background music in the sfx directory. Ensure filenames match those referenced in the code.

### 4. **Images**

Place all background images in the background directory. Ensure filenames match those referenced in the JSON file.

---

## Running the Project

### 1. **Clone the Repository**

```bash
git clone <repository-url>
cd space_walker
```

### 2. **Install Dependencies**

```bash
flutter pub get
```

### 3. **Run the Application**

```bash
flutter run
```

---

## Troubleshooting

### 1. **Missing Assets**

- Ensure all required assets (audio, images, JSON) are placed in the correct directories.

### 2. **Hive Errors**

- If Hive boxes fail to open, ensure the `init()` methods in `FlagService` and `StoryService` are called before accessing the boxes.

### 3. **Audio Issues**

- Verify that audio files are correctly named and placed in the sfx directory.

### 4. **Flutter Errors**

- Run `flutter doctor` to identify and resolve any Flutter-related issues.

### 5. **Debugging Build Runner**

    - If you modify annotated classes, always run build_runner to regenerate files. Verify that generated files (e.g., .g.dart) are correctly created in the expected locations.

```bash
  flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Additional Notes

### 1. **Customizing the Story**

- Modify the `spacewalker.json` file to add or update story nodes, dialogues, choices, and puzzles.

### 2. **Debugging**

- Use `debugPrint` statements in the code to trace issues during runtime.

---

## Credits

### Music

- **Warriyo - Mortals (feat. Laura Brehm) [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/mortals](http://ncs.io/mortals)  
  Watch: [http://youtu.be/yJg-Y5byMMw](http://youtu.be/yJg-Y5byMMw)

- **Max Brhon - AI [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/MB_AI](http://ncs.io/MB_AI)  
  Watch: [http://ncs.lnk.to/MB_AIAT/youtube](http://ncs.lnk.to/MB_AIAT/youtube)

- **NIVIRO - Orphic Night (feat. Diandra Faye) [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/orphicnight](http://ncs.io/orphicnight)  
  Watch: [http://ncs.lnk.to/orphicnightAT/youtube](http://ncs.lnk.to/orphicnightAT/youtube)

- **32Stitches - Olympus [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/Olympus](http://ncs.io/Olympus)  
  Watch: [http://youtu.be/2HhAz5rWzsI](http://youtu.be/2HhAz5rWzsI)

- **Jim Yosef - Samurai [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/Samurai](http://ncs.io/Samurai)  
  Watch: [http://youtu.be/](http://youtu.be/)

- **Lost Sky x Anna Yvette - Carry On [NCS Release]**  
  Music provided by NoCopyrightSounds  
  Free Download/Stream: [http://ncs.io/CarryOn](http://ncs.io/CarryOn)  
  Watch: [http://ncs.lnk.to/CarryOnAT/youtube](http://ncs.lnk.to/CarryOnAT/youtube)

- **For Tomorrow**  
  Composer: Savfk  
  Website: [https://youtube.com/savfkmusic](https://youtube.com/savfkmusic)  
  License: [Creative Commons (BY 4.0)](https://creativecommons.org/licenses/by/4.0/)  
  Music powered by BreakingCopyright: [https://breakingcopyright.com](https://breakingcopyright.com)

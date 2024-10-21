# Movies App 🎬

This is a Flutter-based mobile application that fetches movie data from TheMovieDB API. The app provides users with a seamless interface to browse popular, top-rated, and upcoming movies. It includes detailed movie information such as overviews, release dates, and cast members.
Features:
 - Fetches data using TheMovieDB API.
- Displays movies by categories like Popular, Top Rated, and Upcoming.
- Movie detail view with synopsis, release date, and cast information.
- Clean UI with responsive design for both Android and iOS.
- Built following best practices for Flutter app development.

Feel free to clone, contribute, and suggest improvements!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Steps to Set Up the Tools:

#### 1 .Install Flutter SDK

-  Follow the official Flutter installation guide to install Flutter on your system.
 - Make sure to set up your environment variables as mentioned in the installation steps.
-  Verify Flutter is installed by running:

```bash
    flutter doctor 
```
#### 2. Install Android Studio (or Xcode for iOS)

- Download and install Android Studio.
- Make sure you install the necessary SDKs and emulators for Android development.
- For iOS development (on macOS), install Xcode.
#### 3. Set Up an Editor (Optional)

- Flutter works well with IDEs like Visual Studio Code or Android Studio.
- For VS Code, install the Flutter extension from the marketplace.

#### 4. Clone Your Repository
Clone your GitHub repository containing the movies app:
```bash
git clone https://github.com/yourusername/your-movies-app.git
cd your-movies-app
```

#### 5. Obtain TheMovieDB API Key
- Sign up for an API key from TheMovieDB.
- Replace the API key in your Flutter  in movie_list_screen.dart :
```
 final String apiKey = 'YOUR_API_KEY'
 ```

 #### 6. Install Dependencies
 - Install all required Flutter dependencies by running:
 ```bash
 flutter pub get
 ```

 #### 7. Run the App
 - To run the app on an emulator or physical device, execute:
 ```bash
 flutter run
  ```
Project Name: User Flutter Project
Overview
This is a Flutter-based mobile application designed for booking hotels and restaurants. The app provides a seamless user experience for discovering, viewing, and managing reservations.

Features
User Authentication: Secure user registration and login functionality.

Hotel and Restaurant Listings: Browse through a comprehensive list of available hotels and restaurants.

Detailed Views: Get in-depth information about each hotel and restaurant, including:

Descriptions

Star ratings

Image galleries

Location on a map

Booking and Reservations:

Book tables at restaurants with the ability to pre-order dishes.

Reserve rooms at hotels for specific dates.

Booking Management: View and manage your upcoming restaurant bookings and hotel reservations.

Recommended for You: A personalized recommendation system for restaurants.

Getting Started
To get a local copy up and running, follow these simple steps.

Prerequisites
Flutter SDK: https://flutter.dev/docs/get-started/install

Dart SDK: https://dart.dev/get-dart

An IDE such as Android Studio or Visual Studio Code with the Flutter plugin.

Installation
Clone the repo

Bash

git clone https://github.com/jafarmahmood123/flutter_4th_project.git
Navigate to the project directory

Bash

cd flutter_4th_project
Install dependencies

Bash

flutter pub get
Run the app

Bash

flutter run
Dependencies
This project uses several open-source packages:

provider: For state management.

http: For making API calls to the backend.

shared_preferences: To store the auth token locally.

intl: For internationalization and date formatting.

jwt_decoder: To decode JWT tokens for user information.

url_launcher: To open external links, such as maps.

For a complete list of dependencies, see the pubspec.yaml file.

API Service
The application interacts with a backend service to fetch and manage data. The base URL for the API is https://ef30ed01964c.ngrok-free.app. All API calls are handled through the ApiService class located in lib/core/services/api_service.dart.

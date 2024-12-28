# Pholyfy

A photo gallery app project

## Getting Started

This project is a show case for gallery app project that build using flutter and for the demo I am using unsplash API.

To run this project, you need some setup:
1. Please register to unsplash, you could register [here](https://unsplash.com)
2. After you register, you can create new application and then you will get a Client ID
3. Since this project is implement multiple module for modularization, to make it easier I am using melos. To activate melos, you just need to run `dart pub global activate melos`. Or for detail documentation you could refer to [this](https://melos.invertase.dev/~melos-latest/getting-started#installation) documentation
4. Once melos active, you could get all dependencies in all modules using melos bootstrap. Basically melos bootstrap is running `flutter pub get` in all modules that registered in the melos config in `melos.yaml`
5. For safety, due to I am using Client ID, the secret credential from unsplash I put the Client ID in the .env file. You could run this `cp env.sample .env` in the terminal, and that will create `.env` file
6. You just need to replace <YourClientID> value with your Client ID that you get from unsplash
7. All of the setup should be done, you can run the project now

## Demo

For the demo, i will give the link from google drive. You could find the file [here](https://drive.google.com/file/d/15nmuw-2x2_i_kFZ8U2mHdtXaZJNf4m8N/view?usp=sharing)

## 3rd Party Library Documentation

This is the list of 3rd party library that I used in this project:
1. Dio (for network library). Reference [here](https://pub.dev/packages/dio)
2. Go Router (for navigation library). Reference [here](https://pub.dev/packages/go_router)
3. Cached Network Image (for a widget to show an image from URL and caching it to make it more efficient). Reference [here](https://pub.dev/packages/cached_network_image)
4. Flutter Bloc (for state management, I am using cubit). Reference [here](https://pub.dev/packages/flutter_bloc)

## Features

Some features that been implemented in this project is:
1. Show list of photos using unsplash list photos API
2. Show detail photo when one of the photo in the list been clicked, it will redirect to detail photo with larger image and some detail include description and photographer name
3. Search page. User will be able to search some photo based on the keywords
4. Pagination. Load more photo everytime user scroll down, when user already reach the bottom of the list they could see loading animation to wait the loading for a lil bit. Once the request succeed, it will load everything in the widget and continue pagination.

## Architecture

For architecture, I am trying to implement clean architecture so that it can be easier to maintain and has some kind of clear responsibility for each layer.
I am trying to split the layer to presentation, domain, and data. Also i create couple modules for modularization, like `shared` module. Basically everything that can be reusable
in every modules will be placed in this `shared` module.

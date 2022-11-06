import 'dart:math';

import 'package:flutter/material.dart';


/// screen sizes
const double maxScreenWidth = 1350.0;

/// firebase signIn/signUp errors and success enum
///
enum FirebaseResult { success, somethingWentWrong, invalidCredentials, passwordWrong, userNotFound, userAlreadyExist }

// todo: remove test code
getRandomTestImage() {
  Random random = Random();
  List<String> images = [
    '../assets/images/africa.jpg',
    '../assets/images/animals.jpg',
    '../assets/images/asia.jpg',
    '../assets/images/australia.jpg',
    '../assets/images/europe.jpg',
    '../assets/images/cover.jpg',
    '../assets/images/test3.jpeg',
    '../assets/images/event.jpg',
    '../assets/images/newspaper.jpg',
    '../assets/images/photography.jpeg',
    '../assets/images/north_america.jpg',
    '../assets/images/sample1.jpg',
    '../assets/images/search.png',
    '../assets/images/test1.jpeg',
    '../assets/images/test2.jpeg',
  ];
  return Image.asset(
    images[random.nextInt(images.length - 1)],
    fit: BoxFit.fill,
  );
}

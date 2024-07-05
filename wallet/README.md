# Pylons Wallet

Pylons Wallet

## Getting Started

This project is a starting point for a Flutter application.

1) Req .prod_env file and place it in /wallet/env/ dir.
2) Req GoogleService-Info.plist file and place it in /wallet/ios/runner dir.
3) Req Google-services.json file and place it in /wallet/android/app dir.
4) Remove comments in AppDelegate.swift file to play in ios simulator
5) Req to add generated simulator Debug token to be added in firebase console>ios debug.



1) If you want to connect to our dev testnet use **main_prod.dart**
2) If you want to connect with your local net use **main_local.dart**



In order to change the end points of the GRPC and apis. Go over to env/ folder where you can see two files.
1) **.dev_env** for dev test net endpoints
2) **.local_env** for local endpoints


In order to create production build run this for android 
    `flutter build appbundle --flavor prod -t lib/main_prod.dart`

In order to create production build run this for ios
    `flutter build ios --flavor prod -t lib/main_prod.dart`


In order to create development build run this for ios
    `flutter build ios --flavor development -t lib/main_development.dart`

In order to create development build run this for ios
    `flutter build appbundle --flavor development -t lib/main_development.dart`

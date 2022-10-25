file=$(which flutter)
file=$(dirname "$file");
name=$(dirname "$file");
flutter pub global activate borg
borg $1 --fluttersdk="${name}"
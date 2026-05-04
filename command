icacls "E:\flutter" /grant "${env:USERNAME}:(OI)(CI)F" /T
flutter clean
flutter build apk --release
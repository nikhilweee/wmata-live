# wmatalive

This project was created using [Flutter](https://flutter.dev/).

```
flutter create --org com.nippyapps --platforms android \
    --project-name wmatalive wmata-live
```

# Development

Build and install an APK on a connected device

```console
flutter build apk --target-platform android-arm64 && \
    adb install build/app/outputs/flutter-apk/app-release.apk
```

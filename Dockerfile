# Stage 1: Build Flutter APK
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build apk --release

# Stage 2: Extract the APK
FROM alpine:latest

COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /output/app-release.apk

CMD ["cp", "/output/app-release.apk", "/export/app-release.apk"]

# Stage 1: Build Flutter APK
FROM ghcr.io/cirruslabs/flutter:3.32.4 AS build

ARG BACKEND_URL=https://api.fitmind.dev

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Replace the emulator-only address with the actual backend URL
RUN find lib -name '*.dart' -exec sed -i "s|http://10.0.2.2:8000|${BACKEND_URL}|g" {} +

# Patch compileSdk and ndkVersion to satisfy plugin requirements
RUN sed -i 's/compileSdk = flutter.compileSdkVersion/compileSdk = 36/' android/app/build.gradle.kts \
    && sed -i 's/ndkVersion = flutter.ndkVersion/ndkVersion = "27.0.12077973"/' android/app/build.gradle.kts

ENV GRADLE_OPTS="-Xmx2g -Dorg.gradle.daemon=false"
RUN flutter build apk --release

# Stage 2: Extract the APK
FROM alpine:latest

COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /output/app-release.apk

CMD ["cp", "/output/app-release.apk", "/export/app-release.apk"]

# Stage 1: Build Flutter APK
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build

ARG BACKEND_URL=http://10.0.2.2:8000

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Replace the emulator-only address with the actual backend URL
RUN find lib -name '*.dart' -exec sed -i "s|http://10.0.2.2:8000|${BACKEND_URL}|g" {} +
RUN flutter build apk --release

# Stage 2: Extract the APK
FROM alpine:latest

COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /output/app-release.apk

CMD ["cp", "/output/app-release.apk", "/export/app-release.apk"]

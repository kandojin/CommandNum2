plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.2")

    // Flutter dependencies
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0")
}
buildscript {
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0") // Change version if needed
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0") // Kotlin support
    }
}
android {
    namespace = "com.example.build"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Изменено на Java 17
        targetCompatibility = JavaVersion.VERSION_17 // Изменено на Java 17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // Изменено на Java 17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.build"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

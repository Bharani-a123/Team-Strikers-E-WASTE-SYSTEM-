plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Required for Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ewasteforme"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.ewasteforme"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        create("release") {
            storeFile = file("keystore.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            keyAlias = System.getenv("KEY_ALIAS") ?: ""
            keyPassword = System.getenv("KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            isCrunchPngs = false
            isTestCoverageEnabled = false
        }
    }

    packagingOptions {
        resources.excludes.add("META-INF/*")
        resources.excludes.add("kotlin/**")
        resources.excludes.add("META-INF/*.version")
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM: Aligns all Firebase versions
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))

    // Firebase core services
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")           // Firebase Auth for Email/Password
    implementation("com.google.firebase:firebase-firestore-ktx")      // Firestore for storing usernames

    // Google Sign-In SDK
    implementation("com.google.android.gms:play-services-auth:20.7.0")

    // Support for large apps
    implementation("androidx.multidex:multidex:2.0.1")

    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")
}

repositories {
    google()
    mavenCentral()
}

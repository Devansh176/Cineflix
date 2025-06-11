# 🎬 CineFlex

**CineFlex** is a modern Flutter app to browse, book, and experience movies like never before. It features categorized content, real-time trailers, payment simulation, and local ticket history.

---

## 🚀 Features

- 🎞️ Browse Movies and Series by Language (English & Hindi)
- 🔍 Filter by genre using **TMDB API**
- 🎥 Watch official trailers via **YouTube API**
- 📤 Simulate ticket booking with **Razorpay (Test Mode)**
- 🧾 Share and print tickets as receipts
- 💾 View local ticket history using **Sqflite**
- 🔄 Automatic 3-day cache refresh
- 🌗 Light & Dark Mode toggle with ThemeProvider
- 🧠 State management with Provider
- 📱 Fully responsive design for all devices

---

## 🌐 APIs Used

### 🎬 TMDB API
Used to fetch real-time movie & series data including genres, posters, and descriptions.  
- Categorized by language (Hindi, English)
- Genre-based filtering

### 📺 YouTube API
Integrated to display trailers on the movie description page.  
- Fetches the official trailer using the movie title
- Embedded directly within the app using WebView or YouTubePlayer

> Make sure to set your TMDB and YouTube API keys securely in your app.

---

## 💳 Payment Integration – Razorpay (Test Mode)

CineFlex simulates payments using Razorpay in test mode.

### Setup Steps:

1. **Create Razorpay Test Account**  
   Sign up at [dashboard.razorpay.com](https://dashboard.razorpay.com) → Generate **Test Key ID**

2. **Install SDK**
   ```yaml
   dependencies:
     razorpay_flutter: ^1.3.5
   ```

3. **Integration Snippet**
   ```dart
   var options = {
     'key': 'rzp_test_YourTestKeyHere',
     'amount': 50000,
     'name': 'CineFlex',
     'description': 'Movie Ticket',
     'prefill': {'contact': '9876543210', 'email': 'test@user.com'},
     'external': {'wallets': ['paytm']}
   };
   _razorpay.open(options);
   ```

> Only the **public Key ID** is used in Flutter. Do not expose the secret key.

---

## 🛠 Tech Stack

| Tech              | Usage                                  |
|-------------------|-----------------------------------------|
| **Flutter**       | Cross-platform mobile framework         |
| **Dart**          | Programming language                    |
| **Provider**      | State management                        |
| **Sqflite**       | Local ticket history storage            |
| **Razorpay**      | Payment gateway (test mode)             |
| **TMDB API**      | Fetch movies/series & genre data        |
| **YouTube API**   | Show trailers on description screen     |
| **CachedNetworkImage** | Efficient image loading           |
| **ThemeProvider** | Light/Dark mode toggle                  |

---

## 📁 Folder Structure Overview

```
lib/
├── screens/
│   ├── engMovies.dart
│   ├── hindiMovies.dart
│   ├── engSeries.dart
│   ├── hindiSeries.dart
│   ├── description.dart
│   └── tabs.dart
├── provider/
│   ├── theme_provider.dart
│   └── history_provider.dart
├── database/
│   └── ticket_db_helper.dart
├── widgets/
│   └── Common reusable UI components
├── api/
│   └── tmdb_service.dart, youtube_service.dart
└── main.dart
```

---

## 🔧 Getting Started

Ensure Flutter SDK is installed → [Flutter Install Guide](https://docs.flutter.dev/get-started/install)

```bash
# 1. Clone the project
git clone https://github.com/your-username/cineflex.git
cd cineflex

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 🔐 API Key Setup

Create a `.env` or `constants.dart` file to securely store:

```dart
const TMDB_API_KEY = 'your_tmdb_api_key';
const YOUTUBE_API_KEY = 'your_youtube_api_key';
const RAZORPAY_KEY = 'rzp_test_YourTestKeyHere';
```

Avoid hardcoding keys in version-controlled files.

---

## 📈 Future Enhancements

- 🛒 Live Razorpay integration for production payments
- 🔍 Global search for movies/series
- ❤️ Add to Favorites & Watch Later
- 🧩 Genre chips and year-based filters
- 🌐 External recommendations using collaborative filters

---

## 🧑‍💻 Author

Made with 💙 by **Devansh Dhopte**  
_For any feedback, feature requests, or collaboration – feel free to reach out._

---

_Crafted using Flutter to bring cinema to your fingertips._

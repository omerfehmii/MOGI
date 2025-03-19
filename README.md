# MOGI - AI-Powered Location Analysis App

<p align="center">
  <img src="assets/images/logo.png" alt="MOGI Logo" width="100" height="100">
</p>

MOGI is an AI-powered location analysis and comparison application leveraging OpenAI's advanced language models. It provides users with detailed information, comparisons, and personalized recommendations about areas they want to move to.

## 📱 App Features

### 🗺️ Location Analysis
- **Detailed Area Reviews**: Comprehensive evaluations in terms of safety, transportation, education, healthcare, and social amenities
- **Map Integration**: Visual exploration and discovery of areas
- **Location Search**: Search by address, district, or region name
- **Saving & History**: Save favorite locations and track recently viewed locations

### 🤖 AI Assistant
- **OpenAI (GPT-4o-mini) Integration**: Comprehensive answers to natural language questions via advanced language models
- **Quick Questions**: Fast access to pre-prepared, most frequently asked questions
- **Personalized Recommendations**: Smart suggestions based on user preferences and past interactions
- **Chat History**: Storage and later access to all conversations

### 📊 Location Comparison
- **Multi-Location Comparison**: Compare up to three locations simultaneously
- **Comparison History**: Save completed comparisons for future reference
- **Detailed Analysis Reports**: Analysis of strengths and weaknesses of compared locations
- **AI-Powered Evaluation**: Comprehensive comparison results generated with artificial intelligence

### 💎 Premium Features
- **Mogi Points**: Virtual currency that can be used for premium features
- **Subscription Options**: Weekly and monthly premium subscription plans
- **Unlimited Access**: Unlimited AI chat and location comparison for premium users
- **Priority Support**: Fast support exclusive to premium users

## 📸 Screenshots

<p align="center">
  <img src="screenshots/explore_screen.png" alt="Explore Screen" width="220">
  <img src="screenshots/location_details.png" alt="Location Details" width="220">
  <img src="screenshots/ai_assistant.png" alt="AI Assistant" width="220">
</p>

<p align="center">
  <img src="screenshots/location_comparison.png" alt="Location Comparison" width="220">
  <img src="screenshots/map_view.png" alt="Map View" width="220">
  <img src="screenshots/profile_page.png" alt="Profile Page" width="220">
</p>

## 🔧 Technical Specifications

### Technologies Used
- **Frontend**: Flutter/Dart
- **State Management**: Flutter Bloc
- **Local Database**: Hive
- **Backend Integration**: Supabase
- **Maps**: Flutter Map
- **AI**: OpenAI API
- **HTTP Requests**: http
- **Localization**: intl
- **Secure Storage**: flutter_secure_storage

### Architecture
- **Clean Architecture**: Domain, data, and presentation layers
- **Repository Pattern**: Abstraction between data sources and business logic
- **Service-Oriented**: Separate service classes for each feature
- **Dependency Injection**: Using get_it for dependency injection

## ⚙️ Setup and Running

### Requirements
- Flutter SDK 3.2.3 or higher
- Dart SDK 3.2.3 or higher
- OpenAI API Key
- Supabase Account and API Keys

### Installation Steps

1. Clone the repo:
```bash
git clone https://github.com/omerfehmii/mogi.git
cd mogi
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file and add the necessary API keys:
```
OPENAI_API_KEY=your_openai_api_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
API_BASE_URL=your_api_base_url
```

4. Run the app:
```bash
flutter run
```

## 🛠️ Development

### Project Structure
```
lib/
├── core/                  # Core structures and services
│   ├── constants/         # Constant values
│   ├── errors/            # Error classes
│   ├── network/           # Network operations
│   ├── services/          # Basic services
│   ├── theme/             # Theme definitions
│   └── utils/             # Helper functions
├── features/              # App features
│   ├── ai_assistant/      # AI Assistant feature
│   ├── auth/              # Authentication
│   ├── chat/              # Chat operations
│   ├── location_analysis/ # Location analysis
│   └── profile/           # User profile
└── main.dart              # App entry point
```

### Adding Features
1. Create a new directory under the `features` directory
2. Add data, domain, and presentation layers
3. Add necessary models, services, and UI components
4. Integrate into the main application

## 📝 License
This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer
Developed by an individual developer.

## 📌 Contact
For questions or feedback: [omerfehmicakici@gmail.com](mailto:omerfehmicakici@gmail.com)

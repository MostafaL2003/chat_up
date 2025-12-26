# ChatUp 💬
A real-time, cross-platform mobile chat application built with Flutter and Firebase, focused on instant communication and dynamic social interactions.

---

## 📱 Overview
ChatUp enables users to authenticate, manage friends, and exchange messages in real time.  
The application is designed using clean architecture principles and reactive state management to ensure scalability and maintainability.

---

## ✨ Features
- User authentication (Sign up, Login, Logout)
- Real-time one-to-one messaging using Firestore streams
- Friend request system (Send, Pending, Accept, Decline)
- Profile setup with image upload
- Instant UI updates across the app
- Responsive and reusable UI components

---

## 🧭 Screens
![Login](screenshots/login.png)
![Profile Setup](screenshots/profile_setup.png)
![Chats](screenshots/chats.png)
![Friends](screenshots/friends.png)

---

## 🛠 Tech Stack
- **Flutter (Dart)**
- **State Management:** Bloc / Cubit
- **Backend:** Firebase Firestore
- **Authentication:** Firebase Auth
- **Image Hosting:** Cloudinary

---

## 🧠 Architecture
- Clean Architecture (UI / Business Logic / Data)
- Firestore Streams for real-time updates
- Bloc/Cubit for predictable state handling
- Modular widgets for scalability

---

## 🚀 Getting Started
```bash
git clone https://github.com/MostafaL2003/chatup.git
flutter pub get
flutter run

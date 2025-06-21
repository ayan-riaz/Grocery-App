# 🛒 Grocery App Flutter - Complete Firebase Based Grocery Application

A fully functional grocery shopping mobile app built using **Flutter** and **Firebase**. It features **user authentication**, **real-time database integration**, an **admin panel**, and a working **payment gateway**. The app also supports product **categories**, cart management

---

## ✨ Features

### 👤 User Side
- 🔐 User Authentication (Email & Password via Firebase Auth)
- 🛍️ Browse groceries by categories
- 🛒 Add to Cart / Remove from Cart
- 💳 Checkout with integrated payment method
- ❤️ Add to Favorites

### 🛠️ Admin Panel
- ➕ Add / Edit products
- 📂 Manage categories
- 🔐 Admin login system

---

## 🔧 Tech Stack

| Layer         | Tool/Tech          |
|---------------|--------------------|
| Frontend      | Flutter (Dart)     |
| Backend/Auth  | Firebase Auth       |
| Database      | Firebase Firestore |
| Storage       | Firebase Storage   |
| Admin Panel   | ➕ Add / Edit products |
| Payments      | Stripe / Razorpay / Custom Gateway |

---


## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Firebase project (setup web/app configs)
- Stripe/Razorpay account (if using payments)
- Android Studio / VSCode

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  image_picker: ^1.1.2
  curved_navigation_bar: ^1.0.6
  firebase_core: ^3.13.0
  firebase_auth: ^5.5.3
  get: ^4.7.2
  flutter_riverpod: ^2.6.1
  cloud_firestore: ^5.6.7
  firebase_storage: ^12.4.6
  cloudinary_flutter: ^1.3.0
  http: ^1.4.0
  firebase_app_check: ^0.3.2+7
  flutter_stripe: 9.4.0
  dio: ^5.8.0+1
  firebase_messaging: ^15.2.7
  flutter_dotenv: ^5.1.0

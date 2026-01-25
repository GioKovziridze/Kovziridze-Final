# Kovziridze-Final
# 🛍️ Fashion E-Commerce iOS App

A modern, full-featured e-commerce iOS application built with SwiftUI and UIKit, offering a seamless shopping experience with AI-powered customer support and real-time order tracking.

## ✨ Features

### 🛒 Shopping Experience
- **Product Catalog**: Browse and explore fashion items with an intuitive interface
- **Search & Explore**: Discover products with advanced search functionality
- **Favorites/Wishlist**: Save your favorite items for later
- **Shopping Cart**: Add, update, and manage items in your cart
- **Secure Checkout**: Complete purchases with address management

### 📦 Order Management
- **Real-time Order Tracking**: Live map-based delivery tracking with courier location
- **Order History**: View all your past and current orders
- **Status Updates**: Dynamic order status (Processing, On the Way, Nearby, Delivered)
- **Route Visualization**: See delivery routes on interactive maps using MapKit

### 🤖 AI-Powered Support
- **Intelligent Chat Support**: 24/7 AI assistant powered by Google Gemini
- **Contextual Responses**: Support bot understands order status, cart issues, and account queries
- **Natural Conversations**: Friendly, professional customer service experience
- **Order Assistance**: Get help with tracking, cancellations, and product questions

### 👤 User Authentication & Profile
- **Google Sign-In**: Quick authentication with Google OAuth
- **Email/Password Registration**: Traditional sign-up option
- **Secure Firebase Authentication**: Industry-standard security
- **User Profiles**: Manage account information and preferences
- **City-based Personalization**: Location-aware shopping experience

### 💳 Payment & Data Management
- **Cart Persistence**: Your cart syncs across devices
- **Order Storage**: Secure order history with Firebase Firestore
- **User Data Sync**: Real-time data synchronization
- **Favorites Sync**: Access your wishlist from any device

## 🛠️ Tech Stack

### Frameworks & Libraries
- **SwiftUI**: Modern declarative UI for most views
- **UIKit**: Custom components and complex layouts
- **MapKit**: Real-time order tracking and route visualization
- **Firebase Authentication**: User authentication and management
- **Firebase Firestore**: Cloud database for users, orders, and cart data
- **Google Sign-In SDK**: OAuth authentication
- **GoogleGenerativeAI**: AI-powered customer support (Gemini API)

### Architecture & Patterns
- **MVVM Architecture**: Clean separation of concerns
- **Combine Framework**: Reactive programming for data flow
- **UserDefaults & Firestore**: Hybrid data persistence strategy
- **Singleton Pattern**: Shared stores for user and network management

### Key Components
- **UserStore**: Centralized user data management
- **NetworkManager**: API calls and data fetching
- **Custom Tab Bar**: Floating tab bar with gradient styling
- **Onboarding Flow**: Elegant first-time user experience

## 📱 App Structure

# 📈 CryptoApp

A modern iOS application built with **SwiftUI**, **Combine**, and **MVVM-C** architecture that tracks real-time cryptocurrency data via WebSocket.

https://github.com/yurihp01/cryptoApp/blob/main/app-working.MP4

---

## 📁 Project Structure Explained

### 🧩 App/
- **cryptoApp.swift**: Entry point for the app.
- **Coordinator/**: Implements `AppCoordinator`, `AppRoute`, and manages navigation via `NavigationPath`.

### 🗂 Data/
- **Model/**: Contains domain models like `Crypto`.
- **Repository/**: Holds repository logic and protocol abstraction.
- **Error/**: Defines custom error types such as `CryptoError`.

### 🧱 Features/
#### 🔹 Custom/
- Reusable components, e.g., `ErrorView`.

#### 🔹 Detail/
- **View/**: SwiftUI view showing details of selected crypto.
- **ViewModel/**: `CryptoDetailViewModel` handles the state for the detail screen.

#### 🔹 List/
- **View/**: SwiftUI view listing crypto tickers.
- **ViewModel/**: `CryptoListViewModel` handles live updates and loading logic.

### 🧪 cryptoAppTests/
- **Mock/**: Mocked services and protocols for test isolation.
- **Stub/**: Data stubs used to simulate various test cases.
- **Unit/**: Actual test cases for ViewModels and services.

---

## ⚠️ Observation

> This app **must be tested on a real device**.
>
> Due to simulator limitations, WebSocket connections may not reconnect properly after toggling airplane mode or Wi-Fi. This makes real device testing crucial for accurate network behavior validation.

---

© 2025 Yuri Pedroso. All rights reserved.

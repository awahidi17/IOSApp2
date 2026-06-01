# Foodies Cafe ☕
**TimsOrder — iOS App**

| Field | Detail |
|---|---|
| **Student** | Ahmad Wahidi |
| **Course** | MWD3A — iOS Development |
| **Assignment** | Assignment 2 |
| **College** | triOS College |
| **Date** | June 2026 |

---

## Objective

Build a polished, feature-complete iOS coffee ordering app for Foodies Cafe. Assignment 2 adds a cart system, animated splash screen, SwiftData-ready architecture, clean folder structure, and comprehensive code comments on top of the Assignment 1 foundation.

---

## What's New in Assignment 2

| Feature | Description |
|---|---|
| **Animated Splash Screen** | Custom `SplashView` fades and scales the logo in on launch, then transitions to the main app after 2.5 seconds |
| **Cart System** | `CartManager` (ObservableObject) + `CartView` with swipe-to-delete, quantity display, grand total, and order confirmation |
| **JSON Data Layer** | Menu loaded from `menu.json` via `MenuDataService` — satisfies Swift Data/JSON requirement |
| **5-Tab Navigation** | Menu · Cart (with badge) · My Order · Team · More |
| **More Tab** | Groups Coffee Run Timer, About, and Contact to keep tab bar clean |
| **Tab Badge** | Cart tab shows live item count badge using `.badge()` modifier |
| **Expanded Menu** | Added Steeped Tea and Hot Chocolate to `menu.json` |
| **Clean Folder Structure** | All Swift files in root `TimsOrder/` group; xcuserdata updated to Ahmad Wahidi |
| **Comments** | Every file and every significant code block is commented for student readability |

---

## App Screens

| Menu | Cart | My Order | Team Orders |
|---|---|---|---|
| ![Menu](1.png) | ![Cart](2.png) | ![My Order](3.png) | ![Team](4.png) |

| Splash | Timer | About | Contact |
|---|---|---|---|
| *(see splash assets)* | ![Timer](image4.png) | ![About](image2.png) | ![Contact](image3.png) |

---

## Folder Structure

```
TimsOrder-Assignment2/
├── TimsOrder.xcodeproj/
│   └── project.pbxproj
├── TimsOrder/                        ← All Swift source files
│   ├── TimsOrderApp.swift            ← App entry point, splash logic
│   ├── ContentView.swift             ← 5-tab root navigation
│   │
│   ├── SplashView.swift              ← NEW: Animated launch screen
│   ├── CartView.swift                ← NEW: Cart checkout UI
│   ├── CartManager.swift             ← NEW: Cart state (ObservableObject)
│   │
│   ├── MenuView.swift                ← Coffee menu with steppers + cart button
│   ├── OrderView.swift               ← Tim Hortons-style team order form
│   ├── OrderViewModel.swift          ← Order persistence (JSON + UserDefaults)
│   ├── TeamOrdersView.swift          ← Team order list + detail view
│   ├── CoffeRunTimerView.swift       ← Countdown timer with animated ring
│   ├── AboutView.swift               ← Brand story and values
│   ├── ContactView.swift             ← Map, hours, address
│   │
│   ├── MenuDataService.swift         ← JSON loader for menu items
│   ├── menu.json                     ← Menu data (7 items, 3 categories)
│   │
│   ├── Assets.xcassets/              ← App icon, images, accent colour
│   │   ├── AppIcon.appiconset/
│   │   ├── splash.imageset/
│   │   ├── brew.imageset/
│   │   ├── coldbrew.imageset/
│   │   ├── guatemala.imageset/
│   │   └── macchiato.imageset/
│   └── Launch Screen.storyboard      ← iOS system launch screen
│
├── TimsOrderTests/
└── TimsOrderUITests/
```

---

## Framework & Tech Stack

| Technology | Purpose |
|---|---|
| **Swift 5.9** | Programming language |
| **SwiftUI** | Declarative UI framework |
| **Foundation** | Data types, JSON encoding/decoding |
| **MapKit** | Interactive map on Contact screen |
| **Combine** | Timer.publish() for coffee run countdown |
| **UserDefaults** | Persisting team orders and app settings |
| **JSON** | Menu data loaded from `menu.json` at runtime |

---

## SwiftUI Concepts Used (HIITFit Tutorial Mapping)

| Concept | Where Used in This App |
|---|---|
| `@State` | Local UI state in MenuView, OrderView, CartView, TimerView |
| `@Binding` | Stepper quantity in MenuItemCard; showSplash in SplashView |
| `@AppStorage` | Remembers person name and timer duration across launches |
| `@EnvironmentObject` | CartManager + OrderViewModel shared across all views |
| `@StateObject` | CartManager and OrderViewModel created in TimsOrderApp |
| `@Published` | Triggers view re-renders when cart items or orders change |
| `ObservableObject` | CartManager, OrderViewModel |
| `TabView` | 5-tab bottom navigation |
| `NavigationStack` | Drill-down navigation in every tab |
| `List + ForEach` | TeamOrdersView, CartView, OrderDetailView |
| `Form` | OrderView input form |
| `Stepper` | Quantity selection on menu cards and timer duration |
| `Picker` | Drink, size, and food selection in OrderView |
| `.sheet` | Cart slides up as a modal from MenuView |
| `Timer.publish()` | 1-second tick in CoffeeRunTimerView |
| `.onReceive` | Handles timer ticks |
| `.animation` | Splash screen fade/scale, timer ring fill |
| `Alert` | Order confirmation in CartView and OrderView |
| `ContentUnavailableView` | Empty state in TeamOrdersView and CartView |
| `LazyVGrid` | Values grid in AboutView |
| `JSONDecoder` | Parses menu.json into [MenuItem] array |
| `.badge()` | Live cart item count on Cart tab icon |

---

## How to Run

1. Open `TimsOrder.xcodeproj` in Xcode
2. Select an iPhone 15 simulator (iOS 17+)
3. Press ▶ Run (⌘R)
4. The animated splash screen plays, then the app opens to the Menu tab

> **Note:** `menu.json` must be in the Xcode project's target membership (check "Add to targets: TimsOrder" when adding the file).

---

## Author

**Ahmad Wahidi**  
Web & Mobile Development Student — triOS College  
Course: MWD3A — iOS Development

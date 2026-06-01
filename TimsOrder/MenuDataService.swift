//
//  MenuDataService.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  MenuDataService is a helper that loads the coffee menu from a local JSON file.
//  Using JSON for data satisfies the "Swift Data/JSON" requirement in Assignment 2.
//
//  How it works:
//    1. Look for "menu.json" in the app bundle (the files packaged with the app)
//    2. Read the raw bytes from that file
//    3. Use JSONDecoder to convert those bytes into an array of MenuItem objects
//    4. If anything fails, fall back to the hardcoded sampleMenu array
//
//  Concepts used:
//    - Bundle.main.url() → finds a file that was added to the Xcode project
//    - Data(contentsOf:) → reads the file's bytes into memory
//    - JSONDecoder        → converts JSON → Swift structs (requires Codable)
//    - do/catch          → handles errors without crashing the app
//    - static func       → called on the type itself, not an instance (MenuDataService.loadMenu())
//

import Foundation

struct MenuDataService {

    // MARK: - Load Menu from JSON
    //
    // `static` means you call this as MenuDataService.loadMenu()
    // without creating a MenuDataService object first.
    //
    // Returns: an array of MenuItem objects

    static func loadMenu() -> [MenuItem] {

        // Step 1: Find menu.json in the app bundle
        // Bundle.main is the folder where your app's files live on the device
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "json") else {
            print("⚠️ menu.json not found — using sample data instead")
            return sampleMenu // fallback to hardcoded data
        }

        // Step 2: Try to read + decode the JSON
        // do/catch is Swift's error-handling mechanism (like try/catch in Java)
        do {
            let data = try Data(contentsOf: url)          // read bytes from file
            let decoder = JSONDecoder()
            return try decoder.decode([MenuItem].self, from: data)
            // [MenuItem].self means "decode an array of MenuItem objects"
        } catch {
            // If anything went wrong, print the error and use fallback data
            print("⚠️ Error decoding menu.json: \(error)")
            return sampleMenu
        }
    }

    // MARK: - Sample Menu (Fallback / Preview Data)
    //
    // This hardcoded data is used when:
    //   1. menu.json can't be found in the bundle
    //   2. menu.json contains invalid JSON
    //   3. We need preview data in Xcode Previews
    //
    // `static var` — a property on the type itself (no instance needed)

    static var sampleMenu: [MenuItem] {
        [
            MenuItem(
                name: "Ember Blend",
                description: "Signature medium roast with notes of dark chocolate, caramel, and a hint of smokiness. Perfect for espresso or drip.",
                price: 4.50,
                imageName: "brew",
                category: "Featured Roasts"
            ),
            MenuItem(
                name: "Origin Guatemala",
                description: "Single-origin from Huehuetenango region. Bright acidity, wine-like body, with citrus and floral undertones.",
                price: 5.25,
                imageName: "guatemala",
                category: "Featured Roasts"
            ),
            MenuItem(
                name: "Cold Brew Reserve",
                description: "Specially selected beans cold-brewed for 18 hours. Smooth, naturally sweet, with notes of vanilla and nuts.",
                price: 5.75,
                imageName: "coldbrew",
                category: "Cold Drinks"
            ),
            MenuItem(
                name: "Iced Caramel Macchiato",
                description: "Espresso poured over cold milk and ice, finished with a drizzle of caramel sauce.",
                price: 5.50,
                imageName: "macchiato",
                category: "Cold Drinks"
            ),
            MenuItem(
                name: "French Vanilla Latte",
                description: "Smooth espresso with steamed milk and a touch of sweet vanilla. A crowd favourite.",
                price: 5.00,
                imageName: "brew",
                category: "Hot Drinks"
            )
        ]
    }
}

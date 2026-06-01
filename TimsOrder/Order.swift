//
//  Order.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  Order is the data model for one person's Tim Hortons-style drink order.
//  It is used by the coffee run feature (OrderView + TeamOrdersView).
//
//  Protocol conformances:
//    - Identifiable → gives each Order a unique id so ForEach can use it
//    - Codable      → lets us convert to/from JSON for saving to disk
//    - Equatable    → lets us compare two Orders with == (used in tests)
//

import Foundation

struct Order: Identifiable, Codable, Equatable {

    // MARK: - Properties
    var id: UUID = UUID()           // auto-generated unique identifier
    var personName: String          // who this order belongs to
    var drink: String               // e.g. "Double Double"
    var size: String                // e.g. "Large"
    var extras: [String]            // optional add-ons (e.g. "Oat milk")
    var food: String                // food item, or "None"
    var notes: String               // any special instructions
    var timestamp: Date = Date()    // when the order was saved

    // MARK: - Computed Property
    //
    // A computed property is one that is CALCULATED, not stored.
    // Every time you access `summary`, Swift runs the code and returns
    // the result — it does not take up space in memory.

    /// Short description shown in list rows (e.g. "Large Double Double")
    var summary: String {
        "\(size) \(drink)"
    }
}

// MARK: - Sample Data
//
// Extensions add extra functionality to an existing type.
// This extension adds sample orders used in Xcode Previews and for testing.

extension Order {
    static var sampleOrders: [Order] {
        [
            Order(
                personName: "Ahmad",
                drink: "Double Double",
                size: "Large",
                extras: ["Extra sugar"],
                food: "Chocolate Chip Muffin",
                notes: ""
            ),
            Order(
                personName: "Maria",
                drink: "Steeped Tea",
                size: "Medium",
                extras: ["Oat milk"],
                food: "Everything Bagel",
                notes: "Toasted please"
            ),
            Order(
                personName: "Carlos",
                drink: "Black Coffee",
                size: "Small",
                extras: [],
                food: "None",
                notes: ""
            )
        ]
    }
}

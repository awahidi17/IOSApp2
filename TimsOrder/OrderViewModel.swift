//
//  OrderViewModel.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  Contains OrderViewModel, CartItem, and CartManager in one file
//  so no extra files need to be added to the Xcode project.
//

import Foundation
import SwiftUI
import Combine

// MARK: - OrderViewModel
// Manages team coffee-run orders. Saves/loads via JSON + UserDefaults.
class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private let storageKey = "savedOrders_FoodiesCafe"

    init() { loadOrders() }

    func saveOrder(_ order: Order) {
        if let i = orders.firstIndex(where: { $0.personName.lowercased() == order.personName.lowercased() }) {
            orders[i] = order
        } else {
            orders.append(order)
        }
        persist()
    }

    func deleteOrder(at offsets: IndexSet) {
        orders.remove(atOffsets: offsets)
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Order].self, from: data)
        else { return }
        orders = decoded
    }
}

// MARK: - CartItem
// Wraps a MenuItem with a quantity. Identifiable for use in ForEach/List.
struct CartItem: Identifiable {
    let id       = UUID()
    var menuItem: MenuItem
    var quantity: Int
    var lineTotal: Double { menuItem.price * Double(quantity) }
}

// MARK: - CartManager
// Manages the in-session shopping cart. ObservableObject so views auto-update.
class CartManager: ObservableObject {
    @Published var items: [CartItem] = []

    func addItem(_ menuItem: MenuItem, quantity: Int) {
        if let i = items.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            if quantity <= 0 { items.remove(at: i) }
            else { items[i].quantity = quantity }
        } else if quantity > 0 {
            items.append(CartItem(menuItem: menuItem, quantity: quantity))
        }
    }

    func removeItem(at offsets: IndexSet) { items.remove(atOffsets: offsets) }
    func clearCart() { items = [] }

    var totalItems: Int    { items.reduce(0) { $0 + $1.quantity } }
    var grandTotal: Double { items.reduce(0) { $0 + $1.lineTotal } }
    var isEmpty:    Bool   { items.isEmpty }

    func quantity(for menuItem: MenuItem) -> Int {
        items.first(where: { $0.menuItem.id == menuItem.id })?.quantity ?? 0
    }
}

//
//  MenuView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//

import SwiftUI

// MARK: - MenuItem Model
struct MenuItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var price: Double
    var imageName: String
    var category: String
}

// Maps each menu item name to a custom icon and gradient for the card illustration
// This replaces photo dependencies entirely with beautiful SF Symbol cards
struct MenuItemStyle {
    let symbol: String
    let colors: [Color]
}

func styleFor(_ item: MenuItem) -> MenuItemStyle {
    switch item.name {
    case "Avocado Toast":
        return MenuItemStyle(symbol: "leaf.fill",
            colors: [Color(red:0.18,green:0.62,blue:0.28), Color(red:0.09,green:0.40,blue:0.18)])
    case "Signature Breakfast Bowl":
        return MenuItemStyle(symbol: "bowl.fill",
            colors: [Color(red:0.96,green:0.60,blue:0.10), Color(red:0.80,green:0.36,blue:0.05)])
    case "Grilled Chicken Wrap":
        return MenuItemStyle(symbol: "fork.knife",
            colors: [Color(red:0.60,green:0.30,blue:0.10), Color(red:0.40,green:0.18,blue:0.05)])
    case "Mushroom Flatbread":
        return MenuItemStyle(symbol: "cloud.fill",
            colors: [Color(red:0.42,green:0.32,blue:0.52), Color(red:0.26,green:0.18,blue:0.36)])
    case "Cold Brew":
        return MenuItemStyle(symbol: "drop.fill",
            colors: [Color(red:0.14,green:0.14,blue:0.20), Color(red:0.28,green:0.22,blue:0.36)])
    case "Matcha Latte":
        return MenuItemStyle(symbol: "leaf.circle.fill",
            colors: [Color(red:0.20,green:0.60,blue:0.32), Color(red:0.10,green:0.40,blue:0.22)])
    case "Chocolate Lava Cake":
        return MenuItemStyle(symbol: "flame.fill",
            colors: [Color(red:0.40,green:0.18,blue:0.08), Color(red:0.22,green:0.08,blue:0.04)])
    default:
        return MenuItemStyle(symbol: "star.fill",
            colors: [Color(red:0.10,green:0.62,blue:0.49), Color(red:0.05,green:0.40,blue:0.30)])
    }
}

// MARK: - MenuView
struct MenuView: View {
    @State private var menuItems: [MenuItem] = MenuDataService.loadMenu()
    @State private var quantities: [UUID: Int] = [:]
    @State private var showCart = false
    @EnvironmentObject var cartManager: CartManager

    var groupedItems: [String: [MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
    var sortedCategories: [String] { groupedItems.keys.sorted() }

    // Category header configs
    func categoryConfig(_ cat: String) -> (symbol: String, color: Color) {
        switch cat {
        case "Breakfast": return ("sun.horizon.fill",    Color(red:0.96,green:0.60,blue:0.10))
        case "Lunch":     return ("fork.knife",          Color(red:0.18,green:0.62,blue:0.28))
        case "Drinks":    return ("cup.and.saucer.fill", Color(red:0.14,green:0.48,blue:0.72))
        case "Desserts":  return ("birthday.cake.fill",  Color(red:0.80,green:0.20,blue:0.36))
        default:          return ("square.grid.2x2.fill",Color(red:0.10,green:0.62,blue:0.49))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: Hero Header — dark with coloured food dots
                    ZStack {
                        Color(red: 0.10, green: 0.12, blue: 0.14)
                        VStack(spacing: 10) {
                            Image(systemName: "bowl.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(red:0.10,green:0.62,blue:0.49))
                            Text("Foodies Cafe")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            HStack(spacing: 6) {
                                Text("Fresh").foregroundColor(Color(red:0.18,green:0.72,blue:0.52))
                                Text("·").foregroundColor(.white.opacity(0.4))
                                Text("Flavourful").foregroundColor(Color(red:0.96,green:0.75,blue:0.20))
                                Text("·").foregroundColor(.white.opacity(0.4))
                                Text("Feel-good").foregroundColor(Color(red:0.93,green:0.36,blue:0.36))
                            }
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                        }
                        .padding(.vertical, 28)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(sortedCategories, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 14) {

                                // Category header row
                                let config = categoryConfig(category)
                                HStack(spacing: 8) {
                                    Image(systemName: config.symbol)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(config.color)
                                    Text(category)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                    Spacer()
                                    Text("\(groupedItems[category]?.count ?? 0) items")
                                        .font(.caption).foregroundColor(.secondary)
                                }
                                .padding(.horizontal)

                                // Horizontal scroll of cards for each category
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(groupedItems[category] ?? []) { item in
                                            MenuItemCard(
                                                item: item,
                                                style: styleFor(item),
                                                quantity: Binding(
                                                    get: { quantities[item.id] ?? 0 },
                                                    set: { quantities[item.id] = $0 }
                                                )
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top, 24)

                    // Add to Cart button
                    let totalSelected = quantities.values.reduce(0, +)
                    if totalSelected > 0 {
                        Button(action: addSelectionsToCart) {
                            HStack {
                                Image(systemName: "cart.badge.plus").font(.headline)
                                Text("Add \(totalSelected) Item\(totalSelected == 1 ? "" : "s") to Cart")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding()
                            .background(Color(red:0.10,green:0.62,blue:0.49))
                            .cornerRadius(16)
                            .shadow(color: Color(red:0.10,green:0.62,blue:0.49).opacity(0.35), radius: 10, y: 5)
                        }
                        .padding()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCart = true }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill").font(.title3)
                            if cartManager.totalItems > 0 {
                                Text("\(cartManager.totalItems)")
                                    .font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .background(Color.red).clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                    .foregroundColor(Color("AccentColor"))
                }
            }
            .sheet(isPresented: $showCart) {
                CartView().environmentObject(cartManager)
            }
        }
    }

    private func addSelectionsToCart() {
        for item in menuItems {
            let qty = quantities[item.id] ?? 0
            if qty > 0 { cartManager.addItem(item, quantity: qty) }
        }
        quantities = [:]
    }
}

// MARK: - Menu Item Card
// Illustrated card: gradient background + SF Symbol as the "photo"
struct MenuItemCard: View {
    let item: MenuItem
    let style: MenuItemStyle
    @Binding var quantity: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Illustrated header — gradient + large icon
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(colors: style.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 130)

                // Large decorative icon
                Image(systemName: style.symbol)
                    .font(.system(size: 60, weight: .thin))
                    .foregroundColor(.white.opacity(0.25))
                    .padding(10)

                // Smaller centred icon
                Image(systemName: style.symbol)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Price badge
                Text(String(format: "$%.2f", item.price))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(.black.opacity(0.30))
                    .clipShape(Capsule())
                    .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // Text content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .lineLimit(1)

                Text(item.description)
                    .font(.caption).foregroundColor(.secondary).lineLimit(2)

                // Stepper
                HStack {
                    Text("Qty").font(.caption).foregroundColor(Color("AccentColor"))
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: { if quantity > 0 { quantity -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title3)
                                .foregroundColor(quantity == 0 ? .secondary : Color("AccentColor"))
                        }
                        Text("\(quantity)")
                            .font(.system(size: 16, weight: .bold)).frame(minWidth: 20)
                        Button(action: { if quantity < 10 { quantity += 1 } }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3).foregroundColor(Color("AccentColor"))
                        }
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 210)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MenuView().environmentObject(CartManager())
}

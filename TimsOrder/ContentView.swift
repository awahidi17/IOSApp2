//
//  ContentView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        TabView {
            MenuView()
                .tabItem { Label("Menu", systemImage: "square.grid.2x2.fill") }

            CartView()
                .tabItem { Label("Cart", systemImage: "bag.fill") }
                .badge(cartManager.totalItems > 0 ? cartManager.totalItems : 0)

            OrderView()
                .tabItem { Label("My Order", systemImage: "square.and.pencil") }

            TeamOrdersView()
                .tabItem { Label("Team", systemImage: "person.3.fill") }

            MoreView()
                .tabItem { Label("More", systemImage: "line.3.horizontal") }
        }
        .tint(Color("AccentColor"))
    }
}

// MARK: - MoreView
struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Tools") {
                    NavigationLink(destination: CoffeeRunTimerView()) {
                        Label("Order Run Timer", systemImage: "timer")
                    }
                }
                Section("About") {
                    NavigationLink(destination: AboutView()) {
                        Label("Our Story", systemImage: "book.fill")
                    }
                    NavigationLink(destination: ContactView()) {
                        Label("Find Us", systemImage: "mappin.and.ellipse")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}

// MARK: - CartView
struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showConfirmation = false
    @State private var customerName = ""

    var body: some View {
        NavigationStack {
            Group {
                if cartManager.isEmpty {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color("AccentColor").opacity(0.10))
                                .frame(width: 100, height: 100)
                            Image(systemName: "bag")
                                .font(.system(size: 40))
                                .foregroundColor(Color("AccentColor").opacity(0.5))
                        }
                        Text("Your Bag is Empty")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text("Head to the Menu tab to add delicious items.")
                            .font(.subheadline).foregroundColor(.secondary)
                            .multilineTextAlignment(.center).padding(.horizontal, 40)
                    }
                } else {
                    List {
                        Section("Your Items") {
                            ForEach(cartManager.items) { item in
                                CartItemRow(cartItem: item)
                            }
                            .onDelete { cartManager.removeItem(at: $0) }
                        }

                        Section("Your Name (optional)") {
                            TextField("Enter your name", text: $customerName)
                                .autocorrectionDisabled()
                        }

                        Section("Summary") {
                            HStack {
                                Text("Items").foregroundColor(.secondary)
                                Spacer()
                                Text("\(cartManager.totalItems)").fontWeight(.semibold)
                            }
                            HStack {
                                Text("Total").fontWeight(.bold)
                                Spacer()
                                Text(String(format: "$%.2f", cartManager.grandTotal))
                                    .fontWeight(.bold).foregroundColor(Color("AccentColor"))
                            }
                        }

                        Section {
                            Button { showConfirmation = true } label: {
                                HStack {
                                    Spacer()
                                    Label("Confirm Order", systemImage: "checkmark.seal.fill")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color("AccentColor").cornerRadius(10))
                        }
                    }
                }
            }
            .navigationTitle("My Bag 🛍")
            .toolbar { if !cartManager.isEmpty { EditButton() } }
            .alert("Order Confirmed! 🍽", isPresented: $showConfirmation) {
                Button("Thanks!", role: .cancel) { cartManager.clearCart(); customerName = "" }
            } message: {
                let n = customerName.isEmpty ? "Your" : "\(customerName)'s"
                Text("\(n) order is being prepared fresh. Enjoy!")
            }
        }
    }
}

// MARK: - CartItemRow
struct CartItemRow: View {
    let cartItem: CartItem

    var body: some View {
        HStack(spacing: 14) {
            // Coloured icon tile matching the item's style
            let s = styleFor(cartItem.menuItem)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: s.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Image(systemName: s.symbol)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(cartItem.menuItem.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(cartItem.menuItem.category)
                    .font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("×\(cartItem.quantity)").font(.subheadline).foregroundColor(.secondary)
                Text(String(format: "$%.2f", cartItem.lineTotal))
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(Color("AccentColor"))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(OrderViewModel())
        .environmentObject(CartManager())
}

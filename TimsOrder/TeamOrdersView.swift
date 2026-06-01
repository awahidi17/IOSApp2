//
//  TeamOrdersView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//

import SwiftUI

struct TeamOrdersView: View {
    @EnvironmentObject var viewModel: OrderViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.orders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 52))
                            .foregroundColor(Color("AccentColor").opacity(0.5))
                        Text("No Orders Yet")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        Text("Go to My Order to add your order\nfor the team run.")
                            .font(.subheadline).foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.orders) { order in
                            NavigationLink(destination: OrderDetailView(order: order)) {
                                FoodiesOrderRow(order: order)
                            }
                        }
                        .onDelete(perform: viewModel.deleteOrder)
                    }
                }
            }
            .navigationTitle("🧾 Team Orders")
            .toolbar { EditButton() }
        }
    }
}

struct FoodiesOrderRow: View {
    let order: Order
    var body: some View {
        HStack(spacing: 12) {
            // Coloured avatar circle
            ZStack {
                Circle()
                    .fill(Color("AccentColor").opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(String(order.personName.prefix(1)).uppercased())
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("AccentColor"))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(order.personName).font(.system(size: 15, weight: .semibold))
                Text(order.summary).font(.subheadline).foregroundColor(.secondary)
                if order.food != "None" {
                    Text("🍽 \(order.food)").font(.caption).foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct OrderDetailView: View {
    let order: Order
    var body: some View {
        List {
            Section("Person") { Label(order.personName, systemImage: "person.fill") }
            Section("Drink")  { Label("\(order.size) \(order.drink)", systemImage: "cup.and.saucer.fill") }
            if !order.extras.isEmpty {
                Section("Extras") {
                    ForEach(order.extras, id: \.self) { Label($0, systemImage: "plus.circle") }
                }
            }
            if order.food != "None" {
                Section("Food") { Label(order.food, systemImage: "fork.knife") }
            }
            if !order.notes.isEmpty {
                Section("Notes") { Text(order.notes).italic().foregroundColor(.secondary) }
            }
            Section("Saved") {
                Label(order.timestamp.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
            }
        }
        .navigationTitle("\(order.personName)'s Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { TeamOrdersView().environmentObject(OrderViewModel()) }

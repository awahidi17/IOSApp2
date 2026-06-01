//
//  OrderView.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  OrderView lets a team member build their Tim Hortons-style drink order
//  for the office coffee run. The person's name is remembered using
//  @AppStorage so they don't have to re-enter it each time.
//
//  Concepts used:
//    - @EnvironmentObject → shared OrderViewModel from TimsOrderApp
//    - @AppStorage        → persists the name to UserDefaults automatically
//    - @State             → local UI state for current selections
//    - Form               → grouped input layout built into SwiftUI
//    - Picker             → drop-down / segmented selection control
//    - Alert              → pop-up confirmation after saving
//

import SwiftUI

struct OrderView: View {

    // MARK: - Shared ViewModel
    // Shared across the app — used to save this order to the team list
    @EnvironmentObject var viewModel: OrderViewModel

    // MARK: - Persistent Name
    //
    // @AppStorage("key") automatically reads and writes to UserDefaults.
    // The string "lastPersonName" is the key — it persists even after closing the app.
    // So the user only needs to enter their name once.

    @AppStorage("lastPersonName_Ahmad") private var personName: String = ""

    // MARK: - Local Selections
    //
    // @State variables are local to this view only.
    // They reset when the view disappears unless saved elsewhere.

    @State private var selectedDrink = "Double Double"
    @State private var selectedSize  = "Medium"
    @State private var selectedFood  = "None"
    @State private var notes         = ""
    @State private var selectedExtras: Set<String> = []
    @State private var showConfirmation = false

    // MARK: - Menu Options
    // These arrays define what appears in each Picker / multi-select list

    let drinks = [
        "Double Double", "Black Coffee", "Steeped Tea",
        "Iced Capp", "French Vanilla", "Hot Chocolate", "Latte"
    ]
    let sizes  = ["Small", "Medium", "Large", "Extra Large"]
    let foods  = [
        "None", "Chocolate Chip Muffin", "Everything Bagel",
        "Bagel with Cream Cheese", "Croissant", "Timbit Assortment (10)"
    ]
    let extras = [
        "Extra sugar", "Extra cream", "Oat milk",
        "Almond milk", "Decaf", "Extra shot"
    ]

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {

                // MARK: Name Field
                // TextField binds directly to @AppStorage — saves on every keystroke
                Section("Your Name") {
                    TextField("Enter your name", text: $personName)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words) // capitalize first letters
                }

                // MARK: Drink Picker
                // .navigationLink style pushes a new screen with all drink options
                Section("Drink") {
                    Picker("Select a drink", selection: $selectedDrink) {
                        ForEach(drinks, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.navigationLink)
                }

                // MARK: Size Picker
                // .segmented shows all options side-by-side in a pill-style control
                Section("Size") {
                    Picker("Select size", selection: $selectedSize) {
                        ForEach(sizes, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: Extras (Multi-Select)
                //
                // Each extra is a tappable Button.
                // toggleExtra() adds or removes it from the Set<String>.
                // A Set can't have duplicates — perfect for this use case.

                Section("Extras") {
                    ForEach(extras, id: \.self) { extra in
                        Button(action: { toggleExtra(extra) }) {
                            HStack {
                                Text(extra)
                                    .foregroundColor(.primary)
                                Spacer()
                                // Checkmark appears only if this extra is selected
                                if selectedExtras.contains(extra) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color("AccentColor"))
                                }
                            }
                        }
                    }
                }

                // MARK: Food Picker
                Section("Food") {
                    Picker("Select food", selection: $selectedFood) {
                        ForEach(foods, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.navigationLink)
                }

                // MARK: Notes
                // axis: .vertical allows the field to grow taller as text is entered
                Section("Special Instructions") {
                    TextField("e.g. No lid, toasted...", text: $notes, axis: .vertical)
                        .lineLimit(3)
                }

                // MARK: Save Button
                // .disabled greys out the button when the name field is empty
                Section {
                    Button(action: submitOrder) {
                        HStack {
                            Spacer()
                            Label("Save My Order", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .disabled(personName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("☕ My Order")

            // MARK: Confirmation Alert
            // Shown after the order is saved successfully
            .alert("Order Saved!", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(personName)'s order has been saved to the team list.")
            }
        }
    }

    // MARK: - Toggle Extra Helper
    //
    // Set.contains() returns true if the value is in the set.
    // Set.remove() deletes it; Set.insert() adds it.

    private func toggleExtra(_ extra: String) {
        if selectedExtras.contains(extra) {
            selectedExtras.remove(extra)
        } else {
            selectedExtras.insert(extra)
        }
    }

    // MARK: - Submit Order
    //
    // Builds an Order struct from the current selections
    // and passes it to the shared OrderViewModel.

    private func submitOrder() {
        let order = Order(
            personName: personName.trimmingCharacters(in: .whitespaces),
            drink: selectedDrink,
            size: selectedSize,
            extras: Array(selectedExtras), // convert Set → Array for Codable
            food: selectedFood,
            notes: notes
        )
        viewModel.saveOrder(order)
        showConfirmation = true
    }
}

#Preview {
    OrderView().environmentObject(OrderViewModel())
}

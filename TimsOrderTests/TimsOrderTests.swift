//
//  TimsOrderTests.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  Unit tests for the TimsOrder app.
//  Tests verify that OrderViewModel correctly saves, updates, and deletes orders.
//

import XCTest
@testable import TimsOrder

final class TimsOrderTests: XCTestCase {

    // MARK: - Test: Save a new order
    // Verifies that saving an order adds it to the orders array
    func testSaveNewOrder() throws {
        let viewModel = OrderViewModel()
        viewModel.orders = [] // start clean

        let order = Order(
            personName: "Ahmad",
            drink: "Double Double",
            size: "Large",
            extras: [],
            food: "None",
            notes: ""
        )
        viewModel.saveOrder(order)
        XCTAssertEqual(viewModel.orders.count, 1, "Should have exactly 1 order after saving")
    }

    // MARK: - Test: Update existing order
    // Saving a second order with the same name should replace the first
    func testUpdateExistingOrder() throws {
        let viewModel = OrderViewModel()
        viewModel.orders = []

        let original = Order(personName: "Ahmad", drink: "Double Double", size: "Large", extras: [], food: "None", notes: "")
        let updated  = Order(personName: "Ahmad", drink: "Black Coffee",  size: "Small", extras: [], food: "None", notes: "")

        viewModel.saveOrder(original)
        viewModel.saveOrder(updated)

        XCTAssertEqual(viewModel.orders.count, 1, "Should still have 1 order — update, not duplicate")
        XCTAssertEqual(viewModel.orders.first?.drink, "Black Coffee", "Drink should be updated")
    }

    // MARK: - Test: Delete an order
    func testDeleteOrder() throws {
        let viewModel = OrderViewModel()
        viewModel.orders = []

        let order = Order(personName: "Ahmad", drink: "Latte", size: "Medium", extras: [], food: "None", notes: "")
        viewModel.saveOrder(order)
        viewModel.deleteOrder(at: IndexSet(integer: 0))

        XCTAssertTrue(viewModel.orders.isEmpty, "Orders should be empty after deleting the only order")
    }
}

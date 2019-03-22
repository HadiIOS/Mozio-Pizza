//
//  Mozio_PizzaTests.swift
//  Mozio PizzaTests
//
//  Created by Mac on 14/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import XCTest
@testable import Mozio_Pizza


class Mozio_PizzaTests: XCTestCase {
    func testOrders() {
        testsameOrderPizzas()
        testTwoDifferentFullPizzas()
        testTwoAndHalfPizza()
        testFourDifferentHalvesPizzas()
        testOneFullPizzaAndTwoDifferentHalves()
        testThreeDifferntHalves()
        testOneAndDifferentHalf()
    }
    
    func testsameOrderPizzas() {
        let pizza1 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let d = "1 Pizza1 Pizza"
        testOrders([pizza1, pizza2, pizza3, pizza4], expectedTotal: 16.0, expectedReceipt: [d, d])
    }
    
    func testTwoDifferentFullPizzas() {
        let pizza1 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")

        let d1 = "1 Pizza1 Pizza"
        let d2 = "1 Pizza2 Pizza"
        
        testOrders([pizza1, pizza2, pizza3, pizza4], expectedTotal: 20.0, expectedReceipt: [d1, d2])
    }
    
    func testTwoAndHalfPizza() {
        let pizza1 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")
        let pizza5 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")
        let d1 = "1 Pizza1 Pizza"
        let d2 = "1 Pizza2 Pizza"
        let d3 = "1/2 Pizza2 Pizza"

        testOrders([pizza1, pizza2, pizza3, pizza4, pizza5], expectedTotal: 26.0, expectedReceipt: [d1, d2, d3])
    }
    
    func testFourDifferentHalvesPizzas() {
        let pizza1 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza2", price: 6.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza3", price: 3.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza4", price: 9.0, description: "")
        
        let d1 = "1/2 Pizza1 Pizza"
        let d2 = "1/2 Pizza2 Pizza"
        let d3 = "1/2 Pizza3 Pizza"
        let d4 = "1/2 Pizza4 Pizza"

        testOrders([pizza1, pizza2, pizza3, pizza4], expectedTotal: 22.0, expectedReceipt: [d1, d2, d3, d4])
    }
    
    func testOneFullPizzaAndTwoDifferentHalves() {
        let pizza1 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza3", price: 3.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza4", price: 9.0, description: "")

        let d1 = "1 Pizza1 Pizza"
        let d2 = "1/2 Pizza4 Pizza"
        let d3 = "1/2 Pizza3 Pizza"

        testOrders([pizza1, pizza2, pizza3, pizza4], expectedTotal: 20.0, expectedReceipt: [d1, d2, d3])
    }
    
    func testThreeDifferntHalves() {
        let pizza2 = PizzaOrder(name: "Pizza1", price: 4.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza3", price: 3.0, description: "")
        let pizza4 = PizzaOrder(name: "Pizza4", price: 9.0, description: "")

        let d1 = "1/2 Pizza1 Pizza"
        let d2 = "1/2 Pizza4 Pizza"
        let d3 = "1/2 Pizza3 Pizza"
        
        testOrders([pizza2, pizza3, pizza4], expectedTotal: 16.0, expectedReceipt: [d1, d2, d3])
    }
    
    func testOneAndDifferentHalf() {
        let pizza4 = PizzaOrder(name: "Pizza4", price: 9.0, description: "")
        let pizza2 = PizzaOrder(name: "Pizza4", price: 9.0, description: "")
        let pizza3 = PizzaOrder(name: "Pizza3", price: 3.0, description: "")

        let d2 = "1 Pizza4 Pizza"
        let d3 = "1/2 Pizza3 Pizza"

        testOrders([pizza2, pizza3, pizza4], expectedTotal: 21.0, expectedReceipt: [d2, d3])
    }
    
    private func testOrders(_ pizzas: [PizzaOrder], expectedTotal: Float, expectedReceipt: [String]) {
        let order = Order(pizzas)
        XCTAssert(order.total == expectedTotal, "Total not the same")
        let receipt = order.orders.map({$0.description})
        XCTAssert(receipt.sorted() == expectedReceipt.sorted(), "Receipt not the same")
    }
}

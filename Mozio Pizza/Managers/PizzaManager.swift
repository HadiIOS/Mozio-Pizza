//
//  PizzaManager.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class PizzaManager {
    func fetchPizzas(_ done: @escaping () -> ()) {
        PizzaService().fetchPizzas { (pizzas, error) in
            if let pizzas = pizzas {
                let p = pizzas.map({PizzaObject().decodable($0)})
                DAORealm<PizzaObject>().save(objects: p)
                done()
            } else {
                done()
            }
        }
    }
    
    func getCachedPizzas() -> [PizzaObject] {
        if let realm = try? Realm() {
            return Array(DAORealm<PizzaObject>().load(realm))
        } else {
            return []
        }
    }
    
    func getPizzas(_ pizzaResponse: @escaping ([ViewController.ViewModel.Pizza]) -> ()) {
        //first load cached pizza
        pizzaResponse(self.getCachedPizzas().filter({$0.pizza != nil}).map({$0.pizza!}))
        //second update the cache from server
        fetchPizzas {
            //show cache changes
            pizzaResponse(self.getCachedPizzas().filter({$0.pizza != nil}).map({$0.pizza!}))
        }
    }
    
    func getPizzaObject(for pizza: ViewController.ViewModel.Pizza) -> PizzaObject? {
        
        if let realm = try? Realm() {
            let p = DAORealm<PizzaObject>().load(realm, primaryKey: pizza.toName())
            return p
        } else {
            return nil 
        }
    }
    
    func getOrders(for pizzas: [ViewController.ViewModel.Pizza]) -> [PizzaOrder] {
        let orders = pizzas.map({self.getPizzaObject(for: $0)}).filter({$0 != nil})
        
        var pizzaOrder: [PizzaOrder] = []
        for order in orders {
            pizzaOrder.append(PizzaOrder(name: order!.name, price: order!.price / 2.0, description: ""))
        }
        
        return pizzaOrder
    }
}


struct PizzaOrder {
    let name: String
    var price: Float
    
    static func +(lhs: inout PizzaOrder, rhs: PizzaOrder) -> Float {
        return lhs.price + rhs.price
    }
    
    static func ==(lhs: inout PizzaOrder, rhs: PizzaOrder) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.price == lhs.price
    }
    
    var description: String
}

class Order {
    var orders: [PizzaOrder] = []
    private(set) var total: Float = 0.0
    init(_ orders: [PizzaOrder]) {
        self.orders = orders
        self.setValues()
    }
    
    func setValues() {
        let orderManuplated = orders.enumerated()
        for (idx, order) in orderManuplated {
            let d = "1/2 \(order.name) Pizza"
            total += order.price
            if var existingOrder = orders.filter({$0.description == d}).first {
                existingOrder.description = "1 \(order.name) Pizza"
                existingOrder.price *= 2
                //to ensure data is manuplated correctly
                if idx >= orders.count, let i = orders.firstIndex(where: {$0.name == order.name && $0.description == ""}) {
                    orders[i] = existingOrder
                } else {
                    orders[idx] = existingOrder
                }
                
                //remove one out of two
                if let i = orders.firstIndex(where: {$0.description == d}) {
                    orders.remove(at: i)
                }
            } else {
                var o = order
                o.description = d
                
                if let i = orders.firstIndex(where: {$0.name == order.name && $0.description == ""}) {
                    orders[i] = o
                } else {
                    orders[idx] = o
                }
            }
        }
    }
}

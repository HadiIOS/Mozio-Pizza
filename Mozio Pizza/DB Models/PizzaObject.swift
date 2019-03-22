//
//  PizzaObject.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class PizzaObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Float = 0.0
    var pizza: ViewController.ViewModel.Pizza?  {
        get {
            if name.isEmpty {
                return nil 
            }
            return ViewController.ViewModel.Pizza(name)
        }
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func decodable(_ PizzaC: PizzaCodable) -> PizzaObject {
        self.name = PizzaC.name ?? ""
        self.price = PizzaC.price ?? 0.0
        return self
    }
}


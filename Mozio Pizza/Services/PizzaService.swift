//
//  PizzaService.swift
//  Mozio Pizza
//
//  Created by Hady Nourallah on 19/03/2019.
//  Copyright © 2019 Hady Nourallah. All rights reserved.
//

import Foundation
import Alamofire

class PizzaService {
    func fetchPizzas(_ response: @escaping ([PizzaCodable]?, String?) -> ()) {
        Alamofire.request(RestAPI.getPizzas.url).responseJSON { (dataResponse) in
            if let error = dataResponse.error {
                response(nil, error.localizedDescription)
            } else if let data = dataResponse.data {
                let x = try? JSONDecoder().decode(Safe<[PizzaCodable]>.self, from: data)
                let pizzas = x?.value
                response(pizzas, nil)
            } else {
                response(nil, nil)
            }
        }
    }
}

class PizzaCodable: Codable {
    var name: String?
    var price: Float?
}

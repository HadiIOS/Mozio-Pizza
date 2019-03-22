//
//  ServiceUtil.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

//MARK: Rest API
enum RestAPI {
    case getPizzas
}

extension RestAPI {
    var url: String {
        get {
            return getURL()
        }
    }
    
    private func getURL() -> String {
        switch self {
        case .getPizzas:
            return "\(KEYS.BASE_URL)/pizzas.json"
        
        }
    }
}

//MARK: Codables

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
            print(object_getClassName(value))
        } catch {
            
            
            print(error)
            self.value = nil
        }
    }
}


//MARK: Get Service Keys
open class KEYS {
    static let BASE_URL = "https://static.mozio.com/mobile/tests"
}

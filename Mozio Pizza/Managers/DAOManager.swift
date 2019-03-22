//
//  DAOManager.swift
//  Mozio Pizza
//
//  Created by Hady Nourallah on 19/03/2019.
//  Copyright © 2019 Hady Nourallah. All rights reserved.
//

import Foundation
import RealmSwift

class DAORealm<T: Object> {
    func load(_ realm: Realm) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func load(_ realm: Realm, primaryKey: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func save(_ object: T, update: Bool = true) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(object, update: update)
        }
    }
    
    func save(objects: [T], update: Bool = true) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(objects, update: update)
        }
    }
    
    func delete(realm: Realm, object: T) {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func delete(realm: Realm, objects: [T]) {
        try? realm.write {
            realm.delete(objects)
        }
    }
    
    func clean(realm: Realm) {
        let objects = self.load(realm)
        try? realm.write {
            realm.delete(objects)
        }
    }
}

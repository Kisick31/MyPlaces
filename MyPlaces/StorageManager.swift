//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Ekaterina Shitikova on 08.04.2020.
//  Copyright © 2020 Kisick'n'Kisa. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place){
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Place){
        try! realm.write {
            realm.delete(place)
        }
    }
}

//
//  DataModel.swift
//  MyPlaces
//
//  Created by Ekaterina Shitikova on 07.04.2020.
//  Copyright © 2020 Kisick'n'Kisa. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var restaurantImage: String?
    var image: UIImage?
    
    static let restaurantNames = [
        "Burger Heroes", "Burger King", "KFC",
        "McDonald's", "Сытый Лось", "СушиВок",
        "ТоДаСе", "СПБ Бар", "Контакт-бар",
        "Шоколадница", "Cofix", "Якитория"
    ]
    
    static func getPlaces()->[Place]{
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Москва", type: "Ресторан",
                                restaurantImage: place, image: nil))
        }
        
        return places
    }
}

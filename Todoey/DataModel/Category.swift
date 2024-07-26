//
//  Category.swift
//  Todoey
//
//  Created by Alexander Bokhulenkov on 26.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
//    создаем контейнер
    let items = List<Item>()
}

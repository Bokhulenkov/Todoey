//
//  Item.swift
//  Todoey
//
//  Created by Alexander Bokhulenkov on 26.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //    связь с катерогией
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

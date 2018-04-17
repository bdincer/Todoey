//
//  Item.swift
//  Todoey
//
//  Created by Bora Dincer on 4/17/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Defines relationship to Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

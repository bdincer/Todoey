//
//  Category.swift
//  Todoey
//
//  Created by Bora Dincer on 4/17/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}


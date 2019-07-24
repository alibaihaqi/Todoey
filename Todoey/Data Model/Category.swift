//
//  Category.swift
//  Todoey
//
//  Created by Fadli Al Baihaqi on 23/07/19.
//  Copyright © 2019 Fadli Al Baihaqi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}

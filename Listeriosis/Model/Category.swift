//
//  Category.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/26.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
    
}

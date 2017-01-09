//
//  ToDoListClass.swift
//  CollectionViewApp
//
//  Created by JScharm on 11/17/16.
//  Copyright © 2016 JScharm. All rights reserved.
//

import UIKit

class ToDoListClass: NSObject, NSCoding
{
    var name : String
    
    init(name: String)
    {
        self.name = name

    }
    
    // initalizer used when loading objects of the class
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
    }

    // use for saving
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name,forKey: "name")
    }
}

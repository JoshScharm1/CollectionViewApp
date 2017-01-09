//
//  Person.swift
//  CollectionViewApp
//
//  Created by JScharm on 11/18/16.
//  Copyright © 2016 JScharm. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding
{
    var name : String
    var image : String
    
    init(name: String, image: String)
    {
        self.name = name
        self.image = image
    }
    
    // initalizer used when loading objects of the class
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
        
    }
    
    // use for saving
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name,forKey: "name")
        aCoder.encode(image,forKey: "image")
    }

}

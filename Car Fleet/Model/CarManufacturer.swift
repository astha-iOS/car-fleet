//
//  Manufacturer.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import Foundation

class CarManufacturer {
    var id = String()
    var title:String = ""
    init(id:String, title:String) {    
        self.id = id
        self.title = title
    }
    public var description: String{
        return "{id :"+self.id+"\ntitle : "+self.title+"\n}";
    }
}



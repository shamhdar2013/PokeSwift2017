//
//  RSPokemonSwft.swift
//  RSSwiftPokeDex
//
//  Created by RADHIKA SHARMA on 10/24/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

import Foundation
import UIKit

class Pokemon{
    var name : String
    var id: String
    var type: String
    var height: String
    var weight: String
    var thumbnail: UIImage?
    var spriteUrl: URL?
    
    init?(name: String, id: String, type: String = "Fire", height: String = "10", weight: String = "12", thumbnail: UIImage?, spriteUrl: URL?){
        guard !name.isEmpty else {
            return nil
        }
        self.name = name
        self.id = id
        self.type = type
        self.height = height
        self.weight = weight
        self.thumbnail = thumbnail
        self.spriteUrl = spriteUrl
    }
    
    init?(attributes: [String: String], thumbNail: UIImage?){
        guard !attributes.isEmpty else {
            return nil
        }
        
        name = attributes["name"] ?? " "
        id = attributes["id"] ?? "20"
        type = attributes["type"] ?? "Fire"
        height = attributes["height"] ?? "10"
        weight = attributes["weight"] ?? "12"
        
        var spurl = URL(string:"https/madeup.com")
        if let urlStr = attributes["spriteUrl"] {
         spurl = URL(string:urlStr)
        }
        spriteUrl = spurl
        self.thumbnail = thumbNail
    }
}

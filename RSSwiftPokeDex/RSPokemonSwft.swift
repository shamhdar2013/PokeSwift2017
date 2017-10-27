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
    
    init?(attributes: Dictionary<String, String>, thumbNail: UIImage?){
        guard !attributes.isEmpty else {
            return nil;
        }
        
        let nStr = attributes["name"]
        guard (nStr != nil) else {
            return nil
        }
        self.name = nStr!
        
        let idStr = attributes["id"]
        self.id = (idStr != nil) ? idStr! : "20"
        
        
        let tyStr = attributes["type"]
        self.type = (tyStr != nil) ? tyStr! : "Fire"
        
        let hStr = attributes["height"]
        self.height = (hStr != nil) ? hStr! : "10"
        
        let wStr = attributes["weight"]
        self.weight = (wStr != nil) ? wStr! : "12"
        
        let urlStr = attributes["spriteUrl"]
        self.spriteUrl = (urlStr != nil) ? URL(string:urlStr!) : URL(string:"https/madeup.com")
        
        
        self.thumbnail = thumbNail
        
    }
    
}

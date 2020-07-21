//
//  RSDataFetcherAPI.swift
//  RSSwiftPokeDex
//
//  Created by RADHIKA SHARMA on 10/25/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

import Foundation
import UIKit



class RSDataFetcherAPI{
    
    static let baseUrl = String("https://pokeapi.co/api/v2/pokemon")
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
        case badURL = "ERROR: no valid URL"
    }
    class func getPokemons(completion:@escaping(Array<Dictionary<String, AnyObject>>?, Error?)->Void){
        let session = URLSession.shared
        let urlStr = baseUrl
        let listUrl = URL(string: urlStr)
        let task = session.dataTask(with: listUrl!){ (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? Dictionary<String, AnyObject> else {
                    throw JSONError.ConversionFailed
                }
     
                if  let arr = json["results"] as? Array<Dictionary<String, AnyObject>> {
                   completion(arr, nil)
                } else {
                    let error = JSONError.ConversionFailed as NSError
                    completion(nil, error)
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
                completion(nil, error)
            } catch let error as NSError {
                print(error.debugDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getPokemonDetails(detailsURL: URL, name: String, completion:@escaping(Dictionary<String, String>?, Error?)->Void){
        let session = URLSession.shared
        let task = session.dataTask(with: detailsURL){(data, response, error) in
            do {
                guard let data = data else {
                        throw JSONError.NoData
                }
                    
                guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? Dictionary<String, AnyObject> else {
                        throw JSONError.ConversionFailed
                }
                //print(json)
                var pokeDict = [String: String]()
                pokeDict["name"] = json["name"] as? String ?? " "
                let htVal = json ["height"] as? Int64 ?? 10
                pokeDict["height"] = String("\(htVal)")
                
                let wtVal = json ["weight"] as? Int64 ?? 12
                pokeDict["weight"] = String("\(wtVal)")
                
                let idVal = json["id"] as? Int64 ?? 55
                pokeDict["id"] = String("\(idVal)")
                
                if let sprites = json["sprites"] {
                    let spriteUrl = sprites["front_default"]
                    pokeDict["spriteUrl"] = spriteUrl as? String ?? " "
                }

                if let types = json["types"] as? Array<Dictionary<String, Any>> {
                    let typeVal = types[0]["type"]
                    pokeDict["type"] = typeVal as? String
                }
                
                completion(pokeDict, error)
                
            } catch let error as JSONError {
                print(error.rawValue)
                completion(nil, error)
            } catch let error as NSError {
                print(error.debugDescription)
                completion(nil, error)
            }
            
        }
        task.resume();
    }

    class func getPokemonSprite(spriteURL: URL, name: String, completion:@escaping(UIImage?, Error?)->Void){
        
        let session = URLSession.shared
        let task = session.dataTask(with: spriteURL){(data, response, error) in
            
            if (error != nil){
                completion(nil, error)
            }
            if (data != nil){
                let image:UIImage = UIImage(data:data!)!
                completion(image, nil)
            }
            
        }
        task.resume()
        
    }
    
}

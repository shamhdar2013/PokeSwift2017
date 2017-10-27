//
//  RSDataFetcherAPI.swift
//  RSSwiftPokeDex
//
//  Created by RADHIKA SHARMA on 10/25/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

import Foundation



class RSDataFetcherAPI{
    
    static let baseUrl = String("https://pokeapi.co/api/v2/pokemon")
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    class func getPokemons(completion:@escaping(Array<Dictionary<String, AnyObject>>?, Error?)->Void){
        let session = URLSession.shared
        let urlStr = baseUrl!//+String("/pokemon")
        let listUrl = URL(string: urlStr)
        let task = session.dataTask(with: listUrl!){ (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? Dictionary<String, AnyObject> else {
                    throw JSONError.ConversionFailed
                }
                //print(json)
                
                let arr = json["results"] as! Array<Dictionary<String, AnyObject>>
                
                completion(arr, nil)
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
                pokeDict["name"] = json["name"] as? String
                var htVal = json ["height"] as? Int64
                
                if(htVal == nil){
                    htVal = 10
                }
                pokeDict["height"] = String("\(htVal!)")
                var wtVal = json ["weight"] as? Int64
                if(wtVal == nil){
                   wtVal = 12
                }
                
                pokeDict["weight"] = String("\(wtVal!)")
                var idVal = json["id"] as? Int64
                
                if(idVal == nil){
                    idVal = 55
                }
                pokeDict["id"] = String("\(idVal!)")
                
                let sprites = json["sprites"]
                if(sprites != nil){
                    let spriteUrl = sprites!["front_default"]
                    pokeDict["spriteUrl"] = spriteUrl as? String
                }

                let types = json["types"] as? Array<Dictionary<String, Any>>
                if(types != nil){
                    let typeVal = types![0]["type"]
                    pokeDict["type"] = typeVal as? String
                }
                
                 //print("*******************")
                 //print(pokeDict)
                //print("*******************\n")
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

    
}

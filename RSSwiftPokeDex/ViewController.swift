//
//  ViewController.swift
//  RSSwiftPokeDex
//
//  Created by RADHIKA SHARMA on 9/27/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pokeTableView: UITableView!
    @IBOutlet weak var searchButton: UITabBarItem!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: properties
    var pokemons = [Dictionary<String, AnyObject>]()
    var pokes = [Pokemon]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = NSLocalizedString("table_title", tableName: "Localizable", bundle: Bundle.main, value: "Poke Dex", comment:"Pokedex table title" )
        
        let cellNib = UINib(nibName: "RSPokeTableViewCell", bundle:nil)
        self.pokeTableView.register(cellNib, forCellReuseIdentifier:"RSPokeTableViewCell")
        
        RSDataFetcherAPI.getPokemons(){ (array, error) in
            guard let arr = array  else { return }
            for i in 0..<arr.count {
                self.pokemons.append(arr[i])
            }
            DispatchQueue.global().async{
                self.getPokemonDetails()
            }
            
            DispatchQueue.main.async {
                self.pokeTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //Mark: internal helper functions
    func getPokemonDetails()-> Void {
        
        for i in 0..<pokemons.count {
            if let poke = pokemons[i] as? Dictionary<String, String> {
                let pokeName = poke["name"]
                let detailUrl = URL(string:poke["url"]!)
                
                if(detailUrl != nil){
                    let semaphore = DispatchSemaphore(value: 0)
                    RSDataFetcherAPI.getPokemonDetails(detailsURL: detailUrl!, name: pokeName!){ (dict, error) in
                        
                        if let error = error {
                            print(error)
                        } else {
                            if  let dict = dict {
                                if let pkmn = Pokemon.init(attributes:dict, thumbNail:nil) {
                                    self.pokes.append(pkmn)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: i, section: 0)
                            self.pokeTableView.reloadRows(at: [indexPath], with: .none)
                        }
                        semaphore.signal()
                    }
                    semaphore.wait()
                }
            }
        }
        
        if (pokes.count == pokemons.count){
            DispatchQueue.global().async {
                self.getPokemonSprites()
            }
        }
    }
    
    func getPokemonSprites()->Void {
    
            for i in 0..<self.pokes.count{
                let imgUrl = self.pokes[i].spriteUrl
                if(imgUrl != nil) {
                    let pokeName = self.pokes[i].name
                    let semaphore = DispatchSemaphore(value: 0)
                    RSDataFetcherAPI.getPokemonSprite(spriteURL: imgUrl!, name: pokeName){ (image, error) in
                        
                        if(error != nil){
                            print(error!)
                        } else {
                            
                            if(image != nil){
                                self.pokes[i].thumbnail = image
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(item: i, section: 0)
                                    self.pokeTableView.reloadRows(at: [indexPath], with: .none)
                                }
                                
                            }
                        }
                        semaphore.signal()
                    }
                    semaphore.wait()
                } //if(imgUrl != nil)
            }// end for
    
    }
}

extension ViewController:  UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
   
   return self.pokemons.count
   
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       // Table view cells are reused and should be dequeued using a cell identifier.
       let cellIdentifier = "RSPokeTableViewCell"
       
       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RSPokeTableViewCell  else {
           fatalError("The dequeued cell is not an instance of RSPokeTableViewCell.")
       }
       
       if (pokes.count > indexPath.row) {
           let poke = pokes[indexPath.row]
           cell.nameVal.text = poke.name
           cell.idVal.text = poke.id
           cell.heightVal.text = poke.height
           cell.weightVal.text = poke.weight
           //cell.typeVal.text = poke.type
           cell.spriteImg.image = poke.thumbnail
       } else {
           if let poke = pokemons[indexPath.row] as? Dictionary<String, String> {
               cell.nameVal.text = poke["name"]
           }
       }
       
       return cell
   }
   
   //Mark: TableViewDelegate
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
   {
       return 200.0;//Choose your custom row height
   }
}
   

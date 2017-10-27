//
//  RSPokeTableViewCell.swift
//  RSSwiftPokeDex
//
//  Created by RADHIKA SHARMA on 10/24/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

import UIKit

class RSPokeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameVal: UILabel!
    @IBOutlet weak var idVal: UILabel!
    @IBOutlet weak var heightVal:  UILabel!
    @IBOutlet  weak var weightVal: UILabel!
    //@IBOutlet weak var typeVal: UILabel!
    @IBOutlet weak var spriteImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

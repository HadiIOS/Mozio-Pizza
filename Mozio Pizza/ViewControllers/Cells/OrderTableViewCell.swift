//
//  OrderTableViewCell.swift
//  Mozio Pizza
//
//  Created by Mac on 19/03/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupCell(_ pizza: PizzaOrder) {
        self.nameLabel.text = pizza.description
        self.priceLabel.text = "\(pizza.price) USD"
    }
}

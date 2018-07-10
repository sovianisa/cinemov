//
//  DescriptionTableViewCell.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 11/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    func setDescription(description : String) {
        self.descriptionLabel.text = description
    }
    
}


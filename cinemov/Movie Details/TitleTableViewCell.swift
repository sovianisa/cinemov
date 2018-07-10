//
//  TitleTableViewCell.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 11/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    func setTitle(title : String) {
        self.titleLabel.text = title;
    }
    
    func setReleaseDate(releaseDate : String) {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        if let date = dateFormatterGet.date(from: releaseDate){
            self.releaseDateLabel.text = "Release Date : \(dateFormatterPrint.string(from: date))"
        }
        else {
            self.releaseDateLabel.text = ""
        }
        
    }
    
    
}


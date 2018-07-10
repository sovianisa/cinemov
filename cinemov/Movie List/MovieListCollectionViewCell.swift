//
//  MovieListCollectionViewCell.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 10/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    func showImage(urlPoster : String) {
        self.posterImageView.image = nil
        Alamofire.request("https://image.tmdb.org/t/p/w500/\(urlPoster)", method: .get).responseImage { response in
            if let image = response.result.value {
                
                self.posterImageView.alpha = 0
                self.posterImageView.image = image
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
                    self.posterImageView.alpha = 1
                }, completion: { (Bool) -> Void in    }
                )
            }
            
        }
    }
}



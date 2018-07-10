//
//  Movies.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 11/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit

class Movies: NSObject {
    var movie_id : String!
    var poster : String!
    var title : String!
    var overView : String!
    var releaseDate : String!
    
    init(movie_id: String, poster: String, title: String, overView: String, releaseDate:String) {
        self.movie_id = movie_id
        self.poster = poster
        self.title = title
        self.overView = overView
        self.releaseDate = releaseDate
    }
}


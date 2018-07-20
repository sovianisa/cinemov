//
//  MovieListViewControllerSpec.swift
//  cinemovTests
//
//  Created by Annisa Sofia Noviantina on 19/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Quick
import Nimble
@testable import cinemov

class MovieListViewControllerSpec: QuickSpec {
    override func spec() {
        var vc: MovieListViewController!
        
        describe("MoviesTableViewControllerSpec") {
            beforeEach {
                vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
                _ = vc.view
            }
        }
    }
}

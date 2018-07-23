//
//  MovieDetailViewControllerSpec.swift
//  cinemovTests
//
//  Created by Annisa Sofia Noviantina on 19/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Quick
import Nimble
@testable import cinemov


class MovieDetailViewControllerSpec: QuickSpec {
    override func spec() {
        var vc: MovieDetailViewController!
        
        describe("MovieDetailViewController") {
            beforeEach {
                vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                _ = vc.view
            }
        }
        
    }
}


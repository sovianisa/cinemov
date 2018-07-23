//
//  NetworkManagerSpec.swift
//  cinemovTests
//
//  Created by Annisa Sofia Noviantina on 20/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import cinemov

class NetworkManagerSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("test getMovieList") {
            context("movie list should has 20 movies") {
                it("success") {
                    
                    let networkManager = NetworkManager()
                    networkManager.getMovieList(page:1) { error, json in
                        if error != nil {
                            print("Error: \(error as Optional)")
                        }
                        
                        guard let json = json else {
                            print("something wrong with the json")
                            return
                        }
                        
                        let results = json["results"]
                        expect(results.count).to(equal(20))
                    }
                }
            }
        }
        
        describe("test getSimilarMovies") {
            context("similar movie list should has 17 movies") {
                it("success") {
                    
                    let networkManager = NetworkManager()
                    networkManager.getSimilarMovies(movieID:"351286", page:1) { error, json in
                        if error != nil {
                            print("Error: \(error as Optional)")
                        }
                        
                        guard let json = json else {
                            print("something wrong with the json")
                            return
                        }
                        
                        let results = json["results"]
                        expect(results.count).to(equal(17))
                    }
                }
            }
        }
        
        
    }
}



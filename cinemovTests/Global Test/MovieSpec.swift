
//
//  MovieSpec.swift
//  cinemovTests
//
//  Created by Annisa Sofia Noviantina on 19/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Quick
import Nimble

@testable import cinemov

class MovieSpec: QuickSpec {
    
    override func spec() {
        describe("Create Movie Object") {
            context("Movie should created") {
                let movieObject: Movie = Movie.init(movie_id: "351286", poster: "/c9XxwwhPHdaImA2f1WEfEsbhaFB.jpg", title: "Jurassic World: Fallen Kingdom", overView: "Several years after the demise of Jurassic World, a volcanic eruption threatens the remaining dinosaurs on the island of Isla Nublar. Claire Dearing, the former park manager and founder of the Dinosaur Protection Group, recruits Owen Grady to help prevent the extinction of the dinosaurs once again.", releaseDate: "2018-06-06")
                it("Movie Jurassic World Should Created ") {
                    expect(movieObject.title).to(equal("Jurassic World: Fallen Kingdom"))
                }
            }
        }
    }
    
}


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

class NetworkManagerSpec: QuickSpec, NetworkManagerDelegate {
    
    var results:JSON = [];
    
    override func spec() {
        super.spec()
        
        describe("Delegate testing") {
            context("getMovieList") {
                it("can be tested with toEventually") {
                    let networkManager = NetworkManager()
                    networkManager.delegate = self;
                    networkManager.getMovieList(page: 1)
                    expect(networkManager.delegate?.movieListReceived!(data: nil, error: nil)).toEventuallyNot(beNil());
                }
            }
        }
    }
    
}

//
//  NetworkManager.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 10/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class NetworkManager: NSObject {
    let apiKey: String = "d33d3b2c6a7d77b3a26c241a7111ff88"
    let baseURLString: String = "https://api.themoviedb.org/3/movie"
    var baseURLWithAPIKeyString: String
    
    override init() {
        self.baseURLWithAPIKeyString = "\(self.baseURLString)/"
        super.init()
    }
    
    func getMovieList(page:Int, completionBlock:@escaping (Error?, JSON?) -> ()) {
        let requestURL: String =  "\(baseURLWithAPIKeyString)now_playing?api_key=\(apiKey)&language=en-US&page=\(page)"
        Alamofire.request(requestURL).responseJSON { (response) in
            
            guard response.result.error == nil else {
                completionBlock(response.result.error, nil)
                return
            }
            
            guard let value = response.result.value else {
                completionBlock(response.result.error, nil)
                return
            }
            
            completionBlock(nil, JSON(value))
        }
    }
    
    func getSimilarMovies(movieID:String, page:Int, completionBlock:@escaping (Error?, JSON?) -> ()) {
        let requestURL: String =  "\(baseURLWithAPIKeyString)\(movieID)/similar?api_key=\(apiKey)&language=en-US&page=\(page)"
        
        Alamofire.request(requestURL).responseJSON { (response) in
            
            guard response.result.error == nil else {
                completionBlock(response.result.error, nil)
                return
            }
            
            guard let value = response.result.value else {
                completionBlock(response.result.error, nil)
                return
            }
            
            completionBlock(nil, JSON(value))
        }
    }
    
}





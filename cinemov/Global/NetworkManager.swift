//
//  NetworkManager.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 10/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol NetworkManagerDelegate {
    @objc optional func movieListReceived(data: Any?, error: NSError?)
    @objc optional func similarListReceived(data: Any?, error: NSError?)
}

class NetworkManager: NSObject {
    let apiKey: String = "d33d3b2c6a7d77b3a26c241a7111ff88"
    let baseURLString: String = "https://api.themoviedb.org/3/movie"
    var baseURLWithAPIKeyString: String
    var delegate: NetworkManagerDelegate?
    
    override init() {
        self.baseURLWithAPIKeyString = "\(self.baseURLString)/"
        super.init()
    }
    
    func getMovieList(page:Int) {
        let requestURL: String =  "\(baseURLWithAPIKeyString)now_playing?api_key=\(apiKey)&language=en-US&page=\(page)"
        Alamofire.request(requestURL).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let json = response.result.value else {
                    return
                }
                self.delegate?.movieListReceived!(data: json, error: nil)
            case .failure(let error):
                self.delegate?.movieListReceived!(data: nil, error: error as NSError)
            }
        }
    }
    
    func getSimilarMovies(movieID:String, page:Int) {
        let requestURL: String =  "\(baseURLWithAPIKeyString)\(movieID)/similar?api_key=\(apiKey)&language=en-US&page=\(page)"
        Alamofire.request(requestURL).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let json = response.result.value else {
                    return
                }
                self.delegate?.similarListReceived!(data: json, error: nil)
            case .failure(let error):
                self.delegate?.similarListReceived!(data: nil, error: error as NSError)
            }
        }
    }
    
}



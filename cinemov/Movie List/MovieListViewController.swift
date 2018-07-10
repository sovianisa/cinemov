//
//  MovieListViewController.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 10/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import GCDKit


class MovieListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, NetworkManagerDelegate  {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    // MARK: Variables
    
    var movies: [Movies] = []
    var networkManager = NetworkManager()
    var pageShowing : Int = 0
    
    // MARK: ViewController States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setElements()
        refreshList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Local Functions
    
    func setElements() {
        movieListCollectionView.delegate = self
        movieListCollectionView.dataSource = self
        movieListCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        pageShowing = 1;
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.barTintColor = Utilities.navigationColor()
        navigationItem.title = "Now Playing"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        rightBarButtonItem.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    // MARK: Networking
    
    @objc func refreshList() {
        pageShowing = 1
        loadMovieList(pageShowing: pageShowing)
    }
    
    func loadMovieList(pageShowing:Int){
        
        if pageShowing == 1 {
            networkManager.delegate = self
            SwiftSpinner.show("It's comming...")
            
            if (movies.count > 0) {
                movieListCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                     at: .top,
                                                     animated: false)
                movies = []
                movieListCollectionView.reloadData()
            }
            
        }
        
        GCDQueue.default.async {
            self.networkManager.getMovieList(page: pageShowing)
            }.notify(.main) {
                
        }
    }
    
    func movieListReceived(data: Any?, error: NSError?) {
        SwiftSpinner.hide()
        if error != nil {
            print("Error: \(error as Optional)")
        }
        
        guard let data = data else {
            print("Error: No data")
            return
        }
        
        let json = JSON(data)
        let results = json["results"]
        
        var index = 0
        for result in results.arrayValue {
            if let poster = result["poster_path"].string {
                if let title = result["title"].string {
                    if let overview = result["overview"].string {
                        if let release_date = result["release_date"].string {
                            if let movie_id = Utilities.transformFromJSON(result["id"]){
                                let movie = Movies.init(movie_id: movie_id, poster: poster, title: title, overView: overview, releaseDate: release_date)
                                movies.append(movie)
                                index = index + 1
                            }
                        }
                    }
                }
            }
            
            if (index == results.count-1) {
                pageShowing = pageShowing + 1
                movieListCollectionView.reloadData()
                
            }
            
        }
        
    }
    
    
    // MARK: CollectionView Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        
        let movie = movies[indexPath.row]
        
        if let urlPoster = movie.poster  {
            cell.showImage(urlPoster: urlPoster)
        }
        
        return cell
    }
    
    func collectionView(_ movieListCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let cell  = movieListCollectionView.cellForItem(at: indexPath) as! MovieListCollectionViewCell
        vc.movie =  movies[indexPath.row]
        vc.moviePoster = cell.posterImageView.image
        
        self.navigationController?.pushViewController(vc,animated: true )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == movies.count - 1 {
            loadMovieList(pageShowing: pageShowing)
        }
        
    }
    
    
    
}



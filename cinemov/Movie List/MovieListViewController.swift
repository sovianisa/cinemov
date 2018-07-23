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


class MovieListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    // MARK: Variables
    
    var movies: [Movie] = []
    var networkManager = NetworkManager()
    var pageShowing : Int = 0
    
    // MARK: ViewController States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setElements()
        refreshList()
        
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
            self.getMovieList(page: pageShowing)
            }.notify(.main) {
                
        }
    }
    
    func getMovieList(page:Int){
        
        networkManager.getMovieList(page:page) { error, json in
            SwiftSpinner.hide()
            if error != nil {
                print("Error: \(error as Optional)")
            }
            
            guard let json = json else {
                print("something wrong with the json")
                return
            }
            
            let results = json["results"]
            var index = 0
            for result in results.arrayValue {
                
                if let poster = result["poster_path"].string {
                    if let title = result["title"].string {
                        if let overview = result["overview"].string {
                            if let release_date = result["release_date"].string {
                                if let movie_id = Utilities.transformFromJSON(result["id"]){
                                    let movie = Movie.init(movie_id: movie_id, poster: poster, title: title, overView: overview, releaseDate: release_date)
                                    self.movies.append(movie)
                                    index = index + 1
                                }
                            }
                        }
                    }
                }
                
                if (index == results.count-1) {
                    self.pageShowing = self.pageShowing + 1
                    self.movieListCollectionView.reloadData()
                    
                }
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





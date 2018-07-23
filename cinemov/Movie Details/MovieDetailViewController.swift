//
//  MovieDetailViewController.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 11/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import GCDKit

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: @IBOutlet
    @IBOutlet weak var movieDetailTableView: UITableView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: Variables
    var movie : Movie!
    var similarMovies: [Movie] = []
    var pageShowing : Int = 0
    
    var moviePoster : UIImage!
    var networkManager = NetworkManager()
    var similarCollectionView : UICollectionView!
    
    // MARK: ViewController States
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setElements()
        refreshList()
    }
    
    // MARK: Local Functions
    func setNavigationBar(){
        navigationController?.navigationBar.barTintColor = Utilities.navigationColor()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = movie.title
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    func setElements(){
        posterImageView.image = moviePoster
        
        movieDetailTableView.rowHeight = UITableViewAutomaticDimension
        movieDetailTableView.estimatedRowHeight = 50.0
        
        movieDetailTableView.reloadData()
    }
    
    // MARK: Networking
    
    func refreshList() {
        pageShowing = 1
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        loadSimilarList(pageShowing: pageShowing)
    }
    
    func loadSimilarList(pageShowing:Int){
        
        if pageShowing == 1 {
            SwiftSpinner.show("Wow good choice...")
            
            if (similarMovies.count > 0) {
                similarCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                   at: .top,
                                                   animated: false)
                similarMovies = []
                similarCollectionView.reloadData()
            }
            
        }
        
        GCDQueue.default.async {
            if let movie_id = self.movie.movie_id {
                self.getSimilarMovies(movieID:movie_id, page: pageShowing)
            }
            }.notify(.main) {
                
        }
    }
    
    func getSimilarMovies(movieID:String, page:Int) {
        
        networkManager.getSimilarMovies(movieID:movieID, page:page) { error, json in
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
                                    self.similarMovies.append(movie)
                                    index = index + 1
                                }
                            }
                        }
                    }
                }
                
                if (index == results.count-1) {
                    self.pageShowing = self.pageShowing + 1
                    
                    self.similarCollectionView.delegate = self
                    self.similarCollectionView.dataSource = self
                    
                    self.similarCollectionView.reloadData()
                    self.movieDetailTableView.reloadData()
                    
                }
                
            }
        }
    }
    
    // MARK: TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            if let title = movie.title{
                cell.setTitle(title: title)
            }
            
            if let releaseDate = movie.releaseDate{
                cell.setReleaseDate(releaseDate: releaseDate)
            }
            cell.selectionStyle = .none
            return cell
            
        } else if (indexPath.row == 1) {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            if let description = movie.overView{
                cell.setDescription(description: description)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "SimilarTableViewCell", for: indexPath) as! SimilarTableViewCell
            similarCollectionView = cell.collectionView;
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: CollectionView Functions
    
    func collectionView(_ similarCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ similarCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as! SimilarCollectionViewCell
        
        let movie = similarMovies[indexPath.row]
        if let urlPoster = movie.poster  {
            cell.showImage(urlPoster: urlPoster)
        }
        
        return cell
        
    }
    
    func collectionView(_ similarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let cell  = similarCollectionView.cellForItem(at: indexPath) as! SimilarCollectionViewCell
        vc.movie = similarMovies[indexPath.row]
        vc.moviePoster = cell.posterImageView.image
        
        self.navigationController?.pushViewController(vc,animated: true )
    }
    
}







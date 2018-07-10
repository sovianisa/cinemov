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

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NetworkManagerDelegate  {
    
    // MARK: @IBOutlet
    @IBOutlet weak var movieDetailTableView: UITableView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: Variables
    var movie : Dictionary<String, String> = [:]
    var similarMovies: [Dictionary<String, String>] = []
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Local Functions
    func setNavigationBar(){
        navigationController?.navigationBar.barTintColor = Utilities.navigationColor()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = movie["title"]
        
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
            networkManager.delegate = self
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
            if let movie_id = self.movie["id"] {
                self.networkManager.getSimilarMovies(movieID:movie_id, page: pageShowing)
            }
            }.notify(.main) {
                
        }
    }
    
    func similarListReceived(data: Any?, error: NSError?) {
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
                                let movie = ["title" : title, "poster_path":poster, "id" : movie_id, "release_date" : release_date, "overview" : overview]
                                similarMovies.append(movie)
                                index = index + 1
                            }
                        }
                    }
                }
            }
            
            if (index == results.count-1) {
                print("wow :\(similarMovies.count)")
                pageShowing = pageShowing + 1
                
                similarCollectionView.delegate = self
                similarCollectionView.dataSource = self
                
                similarCollectionView.reloadData()
                movieDetailTableView.reloadData()
                
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
            if let title = movie["title"]{
                cell.setTitle(title: title)
            }
            
            if let releaseDate = movie["release_date"]{
                cell.setReleaseDate(releaseDate: releaseDate)
            }
            cell.selectionStyle = .none
            return cell
            
        } else if (indexPath.row == 1) {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            if let description = movie["overview"]{
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
        if let urlPoster = movie["poster_path"]  {
            cell.showImage(urlPoster: urlPoster)
        }
        
        return cell
        
    }
    
    func collectionView(_ similarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let cell  = similarCollectionView.cellForItem(at: indexPath) as! SimilarCollectionViewCell
        
        let movie = similarMovies[indexPath.row]
        vc.movie = movie
        vc.moviePoster = cell.posterImageView.image
        
        self.navigationController?.pushViewController(vc,animated: true )
        
        
    }
    
    
}



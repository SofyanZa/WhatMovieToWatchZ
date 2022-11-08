//
//  TableViewController.swift
//  WhatMovieToWatchZ
//
//  Created by Sofyan Zarouri on 23/08/2022 
//  Copyright © 2022 Sofyan Zarouri. All rights reserved.
//

import UIKit

///  Table ViewController
class TableViewController: UITableViewController {
    
    /// Top rated outlet
    @IBOutlet weak var topRatedOutlet: UIBarButtonItem!
    /// Popular outlet
    @IBOutlet weak var popularOutlet: UIBarButtonItem!
    /// Films à venir outlet
    @IBOutlet weak var upcomingOutlet: UIBarButtonItem!

    /// Instance de Movie Manager
    private var movieManager = MovieManager()
    /// Instance de Movie Model
    private var movieModel = [MovieModel]()
    /// L'id du tag en int
    private var idTag: Int?
    private var leftBarButton: UIBarButtonItem!
    private var filterMethod = "movie/popular"
    private var isLandscape = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setUp title App to left
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = Key.appName
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        tableView.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifier)
        
        
        popularOutlet.isSelected = true
        
        loadMore()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape = UIDevice.current.orientation.isLandscape
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    /// Configuration de la table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if you need to upload all the images in the future
        //        let numberOfLines = Double(movieModel.count)/3
        //        return Int(ceil(numberOfLines))
        
        var numberRows: Int
        
        if isLandscape {
            numberRows = movieModel.count/6
        } else {
            numberRows = movieModel.count/3
        }
        return numberRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       var rowHight: CGFloat
        
        if isLandscape {
            rowHight = 0.25 * self.view.safeAreaFrame.width
        } else {
            rowHight = 0.5 * self.view.safeAreaFrame.width
        }
        return rowHight
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image1.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image2.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image3.addGestureRecognizer(tapGestureRecognizer3)
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image4.addGestureRecognizer(tapGestureRecognizer4)
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image5.addGestureRecognizer(tapGestureRecognizer5)
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image6.addGestureRecognizer(tapGestureRecognizer6)
        
        cell.configure(with: movieModel, at: indexPath.row, isLandscape: self.isLandscape)
        
        return cell
    }
    
    @objc func viewImage(_ sender: AnyObject) {
        let tag = sender.view.tag
        idTag = tag
        performSegue(withIdentifier: "MainToInfo", sender: self)
    }
    
    /// Envoi des informations d'un controller à un autre
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToInfo" {
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.id = movieModel[idTag!].id
        }
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var numberRows: Int
        
        if isLandscape {
            numberRows = movieModel.count/6-1
        } else {
            numberRows = movieModel.count/3-1
        }
        if indexPath.row == numberRows  {
            loadMore()
            
        }
    }
    
    //MARK: - Sort
    @IBAction func sortButtonPress(_ sender: UIBarButtonItem) {
        
        if sender.isSelected == false {
            topRatedOutlet.isSelected = false
            popularOutlet.isSelected = false
            upcomingOutlet.isSelected = false
            movieModel = []
            nextPage = 1
            
            switch sender.title {
            case "Top rated":
                filterMethod = "movie/top_rated"
                sender.isSelected = true
                
            case "Popular":
                filterMethod = "movie/popular"
                sender.isSelected = true
            default:
                filterMethod = "movie/now_playing"
                sender.isSelected = true
            }
            
            loadMore()
            tableView.reloadData()
        }
        
     }
    
    //MARK: - LoadMore
    
    private var nextPage = 1
    private var currentPage = 1
    
    func loadMore() {
        
        if let modelPage = movieModel.last?.currentPage, let totalPages = movieModel.last?.totalPages {
            currentPage = modelPage
            if modelPage < totalPages {
                nextPage = currentPage + 1
                movieManager.fetchMovies(page: nextPage, sort: filterMethod) {result in
                    switch result {
                    case .success(let movies):
                        self.didUpdateMovie(self.movieManager, movie: movies)
                    case .failure(let error):
                        self.didFailWithError(error: error)
                    }
                    
                }
            }
        } else {
            movieManager.fetchMovies(page: nextPage, sort: filterMethod){result in
                switch result {
                case .success(let movies):
                    self.didUpdateMovie(self.movieManager, movie: movies)
                case .failure(let error):
                    self.didFailWithError(error: error)
                }
                
            }
            
        }
       }
    }

//MARK: - MovieManagerDelegate
extension TableViewController {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        DispatchQueue.main.async {
            
            for n in movie {
                self.movieModel.append(n)
            }
            
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Error", message: "There was a problem loading content.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        print("aqui\(error)")
    }
}

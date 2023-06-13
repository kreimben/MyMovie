//
//  SearchViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchTextField: UITextField?
    @IBOutlet var searchButton: UIButton?
    @IBOutlet var searchResultsTableView: UITableView?
    
    private var searchedResults: Dictionary<Int, MovieMetadata> = Dictionary()
    private var movies: Array<MovieMetadata> = Array()
    
    private var credits: [Credit] = CSVHelper.getCredits()
    private var moviesMetadata: Dictionary<Int, MovieMetadata> = CSVHelper.getMoviesMetadata()
    private var image = UIImage(named: "poster_sample.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        self.searchResultsTableView?.dataSource = self
        self.searchResultsTableView?.delegate = self
        let cell = UINib(nibName: "Top20TableViewCell", bundle: .main)
        self.searchResultsTableView?.register(cell, forCellReuseIdentifier: "Top20TableViewCell")
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(100, searchedResults.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top20TableViewCell", for: indexPath) as! Top20TableViewCell
        
        if indexPath.row < self.movies.count {
            let curr = self.movies[indexPath.row]
            
            cell.movieTitle?.text = "\(indexPath.row + 1). \(curr.title)"
            cell.movieOverview?.text = curr.overview
            cell.movieVoteCount?.text = String(curr.vote_count)
            cell.movieVoteAverage?.text = String(curr.vote_average)
            cell.movieID?.text = String(curr.id)
            cell.movieThumbnail?.image = self.image
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(128 + 4 + 4)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // populate cell info
        let curr = self.movies[indexPath.row]
        // ready VC with navCon
        let detailVC = MovieDetailViewController(detail: curr)
        let len = self.tabBarController!.viewControllers!.count
        self.tabBarController!.viewControllers![len - 1] = detailVC
        self.tabBarController!.selectedIndex = self.tabBarController!.viewControllers!.count - 1
    }
}

extension SearchViewController {
    func containsCaseInsensitive(_ string: String, _ substring: String) -> Bool {
        let range = string.range(of: substring, options: .caseInsensitive)
        return range != nil
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let keyword = self.searchTextField?.text else {
            return
        }
        
//        print("search keyword: \(keyword)")
        
        // search movie itself first.
        self.searchedResults = self.moviesMetadata
            .filter { self.containsCaseInsensitive($1.title, keyword) }
        
//        print("searched results: \(self.searchedResults.count)")
        
        // search name second.
        let searchedCredit = self.credits
            .filter { $0.cast.filter { self.containsCaseInsensitive($0.name, keyword) }.count > 0 }
        print("searched credit: \(searchedCredit)")
        for credit in searchedCredit {
            if !self.searchedResults.contains(where: { dictId, _ in return dictId == credit.id }) {
                // if there is no any id in `self.searchedResults`.
                self.searchedResults[Int(credit.id)] = self.moviesMetadata[Int(credit.id)]
            }
        }
        
//        print("search final: \(self.searchedResults)")
        
        self.movies = Array(self.searchedResults.values)
        self.movies.sort { $0.vote_average > $1.vote_average }
        
        self.searchResultsTableView?.reloadData()
    }
}

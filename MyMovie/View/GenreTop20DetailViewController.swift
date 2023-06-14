//
//  GenreTop20DetailViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class GenreTop20DetailViewController: UIViewController {
    
    private var movies: Array<MovieMetadata> = []
    private var genreName = ""
    
    @IBOutlet var navBar: UINavigationBar?
    @IBOutlet var genreTop20DetailTableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navBar?.topItem?.title = self.genreName
        
        // table view
        self.genreTop20DetailTableView?.dataSource = self
        self.genreTop20DetailTableView?.delegate = self
        let cell = UINib(nibName: "Top20TableViewCell", bundle: .main)
        self.genreTop20DetailTableView?.register(cell, forCellReuseIdentifier: "Top20TableViewCell")
        self.genreTop20DetailTableView?.allowsSelection = false
    }
    
    convenience init(moviesMetadata: Array<MovieMetadata>, genreName: String = "") {
        self.init()
        self.movies = moviesMetadata
        self.genreName = genreName
        self.genreTop20DetailTableView?.reloadData()
    }
}


extension GenreTop20DetailViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(128 + 4 + 4)
    }
}


extension GenreTop20DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(20, self.movies.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top20TableViewCell", for: indexPath) as! Top20TableViewCell
        
        if indexPath.row < self.movies.count {
            let curr = self.movies[indexPath.row]
            
            cell.movieTitle?.text = "\(indexPath.row + 1). \(curr.title ?? "N/A")"
            cell.movieOverview?.text = curr.overview
            cell.movieVoteCount?.text = String(curr.vote_count)
            cell.movieVoteAverage?.text = String(curr.vote_average)
            cell.movieID?.text = String(curr.movie_id)
        }
        
        return cell
    }
}

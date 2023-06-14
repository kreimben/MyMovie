//
//  ViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class Top20ViewController: UIViewController {
    
    @IBOutlet var top20Button: UIButton?
    @IBOutlet var top20TableView: UITableView?
    
    // MARK: CoreData Context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var movies: Array<MovieMetadata> = []
    private func fetchMovies() {
        self.movies = try! context.fetch(MovieMetadata.fetchRequest())
        DispatchQueue.main.async {
            self.top20TableView?.reloadData()
        }
    }
    
    private let image = UIImage(named: "poster_sample.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchMovies()
        
        // table view
        self.top20TableView?.dataSource = self
        self.top20TableView?.delegate = self
        let cell = UINib(nibName: "Top20TableViewCell", bundle: .main)
        self.top20TableView?.register(cell, forCellReuseIdentifier: "Top20TableViewCell")
        self.top20TableView?.allowsSelection = false
        
        // menu button
        self.movies.sort { $0.vote_count > $1.vote_count }
        
        let voteCount = UIAction(title: "평가 갯수", handler: { _ in
            self.movies.sort { $0.vote_count > $1.vote_count }
            self.top20TableView?.reloadData()
        })
        let voteAverage = UIAction(title: "평균 평점", handler: { _ in
            self.movies.sort { $0.vote_average > $1.vote_average }
            self.top20TableView?.reloadData()
        })
        self.top20Button?.menu = UIMenu(
            title: "정렬 방법을 선택해 주세요.",
            children: [voteCount, voteAverage]
        )
    }
}

extension Top20ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top20TableViewCell", for: indexPath) as! Top20TableViewCell
        
        let curr = self.movies
        
        cell.movieTitle?.text = "\(indexPath.row + 1). \(curr[indexPath.row].title)"
        cell.movieOverview?.text = curr[indexPath.row].overview
        cell.movieVoteCount?.text = String(curr[indexPath.row].vote_count)
        cell.movieVoteAverage?.text = String(curr[indexPath.row].vote_average)
        cell.movieID?.text = String(curr[indexPath.row].movie_id)
        cell.movieThumbnail?.image = self.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
}

extension Top20ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(128 + 4 + 4)
    }
}

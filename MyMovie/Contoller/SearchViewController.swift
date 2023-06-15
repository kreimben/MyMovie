//
//  SearchViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet var searchTextField: UITextField?
    @IBOutlet var searchButton: UIButton?
    @IBOutlet var searchResultsTableView: UITableView?
    
    // MARK: CoreData Context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var searchedResults: Array<MovieMetadata> = []
    
    private func findMoviesByKeywordOrName(keyword: String) {
        let req: NSFetchRequest<MovieMetadata> = MovieMetadata.fetchRequest()
        var res: Set<MovieMetadata> = Set()
        
        var pred = NSPredicate(format: "title CONTAINS[cd] %@", keyword)
        req.predicate = pred
        let moviesByKeyword = try! context.fetch(req)
        moviesByKeyword.forEach { res.insert($0) }
        
        let casts = self.findCastsByName(name: keyword)
        print("searched casts: \(casts.count)")
//        for cast in casts {
//            guard let c = cast.credits else { continue }
//            let credits = c.allObjects
//            print("there are \(credits.count) credits")
            
        let castReq: NSFetchRequest<MovieMetadata> = MovieMetadata.fetchRequest()
        pred = NSPredicate(format: "credit.casts == %@", casts)
        let ord = NSSortDescriptor(key: "vote_average", ascending: false)
        req.predicate = pred
        req.sortDescriptors = [ord]
        let moviesByCast = try! context.fetch(castReq)
        moviesByCast.forEach { res.insert($0) }
            
//            for credit in credits {
//                let newReq: NSFetchRequest<MovieMetadata> = MovieMetadata.fetchRequest()
//                pred = NSPredicate(format: "credit == %@", credit as! Credit)
//                let ord = NSSortDescriptor(key: "vote_average", ascending: false)
//                req.predicate = pred
//                req.sortDescriptors = [ord]
//                let moviesByCredit = try! context.fetch(newReq)
//                moviesByCredit.forEach { res.append($0) }
//            }
//        }
        print("total \(res.count) movies searched")
        
        self.searchedResults = Array(res)
        self.searchedResults.sort { $0.vote_average > $1.vote_average }
        
        DispatchQueue.main.async {
            self.searchResultsTableView?.reloadData()
        }
    }
    
    private func findCastsByName(name: String) -> [Cast] {
        print("searching name: \(name)")
        let req = Cast.fetchRequest()
        let pred = NSPredicate(format: "name CONTAINS[cd] %@", name)
        req.predicate = pred
        let res = try! self.context.fetch(req)
        res.forEach { print("name: \(String(describing: $0.name))") }
        return res
    }
    
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
        
        if indexPath.row < self.searchedResults.count {
            let curr = self.searchedResults[indexPath.row]
            
            cell.movieTitle?.text = "\(indexPath.row + 1). \(curr.title ?? "N/A")"
            cell.movieOverview?.text = curr.overview
            cell.movieVoteCount?.text = String(curr.vote_count)
            cell.movieVoteAverage?.text = String(curr.vote_average)
            cell.movieID?.text = String(curr.movie_id)
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
        let curr = self.searchedResults[indexPath.row]
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
//
////        search movie itself first.
//        self.searchedResults = self.moviesMetadata
//            .filter { self.containsCaseInsensitive($1.title, keyword) }
//
//
//        print("searched results: \(self.searchedResults.count)")
//
////        search name second.
//        let searchedCredit = self.credits
//            .filter { $0.cast.filter { self.containsCaseInsensitive($0.name, keyword) }.count > 0 }
//        print("searched credit: \(searchedCredit)")
//        for credit in searchedCredit {
//            if !self.searchedResults.contains(where: { dictId, _ in return dictId == credit.id }) {
//                // if there is no any id in `self.searchedResults`.
//                self.searchedResults[Int(credit.id)] = self.moviesMetadata[Int(credit.id)]
//            }
//        }
//
//        print("search final: \(self.searchedResults)")
//
//        self.movies = Array(self.searchedResults.values)
//        self.movies.sort { $0.vote_average > $1.vote_average }
//
//        self.searchResultsTableView?.reloadData()
        
        self.findMoviesByKeywordOrName(keyword: keyword)
    }
}

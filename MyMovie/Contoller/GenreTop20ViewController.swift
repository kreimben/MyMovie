//
//  GenreTop20ViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class GenreTop20ViewController: UIViewController {
    
    @IBOutlet var genreTableView: UITableView?
    
    private let genres = Array(AllGenres)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        self.genreTableView?.dataSource = self
        self.genreTableView?.delegate = self
        let nib = UINib(nibName: "GenreTop20TableViewCell", bundle: .main)
        self.genreTableView?.register(nib, forCellReuseIdentifier: "GenreTop20TableViewCell")
    }
}


extension GenreTop20ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // filter movie meta data with selected genre.
        let currentSelectedGenre = self.genres[indexPath.row]
        let newMovieMetadata = CSVHelper.getMoviesMetadata()
            .filter { $1.genres.contains(currentSelectedGenre) }
        
        // ready for VC.
        let rootCon = GenreTop20DetailViewController(
            moviesMetadata: newMovieMetadata,
            genreName: currentSelectedGenre.name
        )
        let navCon = UINavigationController(rootViewController: rootCon)
        self.present(navCon, animated: true)
    }
}

extension GenreTop20ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllGenres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTop20TableViewCell", for: indexPath) as! GenreTop20TableViewCell
        
        cell.genreName.text = self.genres[indexPath.row].name
        
        return cell
    }
}

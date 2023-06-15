//
//  GenreTop20ViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class GenreTop20ViewController: UIViewController {
    
    @IBOutlet var genreTableView: UITableView?
    
    // MARK: CoreData Context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var genres: [Genre] = []
    private func fetchGenres() {
        self.genres = try! self.context.fetch(Genre.fetchRequest())
        DispatchQueue.main.async {
            self.genreTableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchGenres()
        
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
        let movies: Set<MovieMetadata> = currentSelectedGenre.metadata! as! Set<MovieMetadata>
        
        // ready for VC.
        let rootCon = GenreTop20DetailViewController(
            movies: Array(movies),
            genreName: currentSelectedGenre.name!
        )
        let navCon = UINavigationController(rootViewController: rootCon)
        self.present(navCon, animated: true)
    }
}

extension GenreTop20ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTop20TableViewCell", for: indexPath) as! GenreTop20TableViewCell
        
        cell.genreName.text = self.genres[indexPath.row].name
        
        return cell
    }
}

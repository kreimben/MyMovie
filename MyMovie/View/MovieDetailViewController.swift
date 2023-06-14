//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/06/01.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var movieTitle: UILabel?
    @IBOutlet var movieVoteAverage: UILabel?
    @IBOutlet var movieReleaseDate: UILabel?
    @IBOutlet var moviePlayTime: UILabel?
    @IBOutlet var movieIsAdult: UILabel?
    @IBOutlet var movieThumbnail: UIImageView?
    
    @IBOutlet var reviewTableView: UITableView?
    @IBOutlet var reviewTextField: UITextField?
    
    private var movie: MovieMetadata?
    private var ratings: [Rating] = CSVHelper.getRatings()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let items = self.tabBarController!.tabBar.items else { return }
        items[items.count - 1].title = "Detail"
        items[items.count - 1].image = UIImage(systemName: "circle.fill")
        
        self.movieThumbnail?.image = UIImage(named: "poster_sample.jpg")
        
        if self.movie == nil {
            self.movieTitle?.text = "Empty Info"
        } else {
            self.movieTitle?.text = self.movie?.title
            self.movieVoteAverage?.text = String(self.movie?.vote_average ?? 0.0)
            let year = self.movie?.release_date.split(separator: "-")[0]
            self.movieReleaseDate?.text = String(year!)
            self.moviePlayTime?.text = self.movie!.runtime + "분"
            self.movieIsAdult?.text = self.movie!.adult ? "성인영화" : "성인영화 아님"
        }
        
        // Filter by `movieId`.
        if self.movie != nil {
            self.ratings = self.ratings.filter { $0.movie_id == self.movie!.id }
        }
        self.ratings.sort { $0.user_id < $1.user_id }
        
        self.reviewTableView?.dataSource = self
        self.reviewTableView?.delegate = self
        let nib = UINib(nibName: "RatingTableViewCell", bundle: .main)
        self.reviewTableView?.register(nib, forCellReuseIdentifier: "RatingTableViewCell")
        self.reviewTableView?.reloadData()
    }
    
    convenience init(detail movie: MovieMetadata) {
        self.init()
        self.movie = movie
    }
}

extension MovieDetailViewController {
    @IBAction func review(_ sender: UIButton) {
        print("before self.movie nil")
        if self.movie == nil { return }
        print("after self.movie nil")
        
        print("before guard")
        guard let ratingString = self.reviewTextField!.text,
              let rating = Float(ratingString) else { print("rating convert error"); return }
        print("after guard")
        print("rating: \(rating)")
        
        if !(0.0...10.0).contains(rating) {
            let alertController = UIAlertController(title: "범위가 올바르지 않습니다.", message: "0과 10사이의 숫자를 적어주세요.", preferredStyle: .alert)
            let alert = UIAlertAction(title: "OK", style: .default)
            self.present(alertController, animated: true)
            return
        }
        
        self.ratings.append(
            Rating(
                user_id: 0 as UInt32,
                movie_id: self.movie!.id,
                rating: rating,
                timestamp: UInt64(0)
            )
        )
        
        self.ratings.sort { $0.user_id < $1.user_id }
        self.reviewTableView?.reloadData()
        
        print("성공적으로 리뷰를 하였습니다.")
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.movie == nil {
            return 0
        } else {
            return self.ratings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
        
        let i = indexPath.row
        cell.userId?.text = String(self.ratings[i].user_id)
        cell.rating?.text = String(self.ratings[i].rating)
        
        return cell
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

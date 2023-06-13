//
//  Top20TableViewCell.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class Top20TableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel?
    @IBOutlet var movieOverview: UILabel?
    @IBOutlet var movieVoteAverage: UILabel?
    @IBOutlet var movieVoteCount: UILabel?
    @IBOutlet var movieID: UILabel?
    @IBOutlet var movieThumbnail: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

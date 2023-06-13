//
//  RatingTableViewCell.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/06/13.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    
    @IBOutlet var userId: UILabel?
    @IBOutlet var rating: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // did nothing.
    }
    
}

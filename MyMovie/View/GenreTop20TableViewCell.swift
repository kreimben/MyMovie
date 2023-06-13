//
//  GenreTop20TableViewCell.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit

class GenreTop20TableViewCell: UITableViewCell {
    
    @IBOutlet var genreName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

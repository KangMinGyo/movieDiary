//
//  HomeTableViewCell.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/29.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: CustomImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieRank: UILabel!
    @IBOutlet weak var audiNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

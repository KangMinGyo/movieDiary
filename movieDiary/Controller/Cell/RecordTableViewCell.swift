//
//  RecordTableViewCell.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/03.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var recordDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

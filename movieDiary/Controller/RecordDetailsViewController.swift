//
//  RecordDetailsViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/03.
//

import UIKit

class RecordDetailsViewController: UIViewController {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReview: UILabel!
    
    var movieNm : String = ""
    var movieRv : String = ""
    var star : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieName.text = movieNm
        movieReview.text = movieRv
        print(star)
        
        var value = star
        
        for index in 0...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if value > 0.5 {
                    value -= 1
                    starImage.image = UIImage(systemName: "star.fill")
                } else if 0 < value && value < 0.5 {
                    value -= 0.5
                    starImage.image = UIImage(systemName: "star.leadinghalf.filled")
                } else {
                    starImage.image = UIImage(systemName: "star")
                }
        }
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

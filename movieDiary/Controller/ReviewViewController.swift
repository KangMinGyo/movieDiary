//
//  ReviewViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/01.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var movieName : String = ""
    var movieInfo : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieNameLabel.text = movieName
    }
    

    @IBAction func saveButton(_ sender: UIButton) {
        guard let review = reviewTextView.text, review.count > 0 else {
            print("메모를 입력하세요")
            return
        }
        DataManager.shared.addNewReview(review, movieName, movieInfo)
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

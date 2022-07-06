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
    
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starStackView: UIStackView!
    
    var movieName : String = ""
    var movieInfo : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieNameLabel.text = movieName
    }
    
    // MARK: - 별점 시스템
    @IBAction func moveStarSlider(_ sender: UISlider) {
        var value = starSlider.value
        print(value)
        
        // star.leadinghalf.filled
        //starImage.image = UIImage(systemName: "star.fill")
        
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
    
    // MARK: - 메모 입력

    @IBAction func saveButton(_ sender: UIButton) {
        guard let review = reviewTextView.text, review.count > 0 else {
            print("메모를 입력하세요")
            return
        }
        DataManager.shared.addNewReview(review, movieName, movieInfo)
        self.presentingViewController?.dismiss(animated: true)
    }

    // MARK: - 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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

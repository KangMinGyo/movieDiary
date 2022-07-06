//
//  ReviewViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/01.
//

import UIKit

class ReviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starStackView: UIStackView!
    
    var movieName : String = ""
    var movieInfo : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieNameLabel.text = movieName
        
        reviewTextView.delegate = self
        reviewTextView.text = "내용을 입력하세요."
        reviewTextView.textColor = UIColor.lightGray
    }
    
    // MARK: - 별점 시스템
    @IBAction func moveStarSlider(_ sender: UISlider) {
        var value = starSlider.value
        print(value)

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
        
        //데이터 전달
        DataManager.shared.addNewReview(review, movieName, movieInfo)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == UIColor.lightGray {
            reviewTextView.text = ""
            reviewTextView.textColor = UIColor.black
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty {
            reviewTextView.text = "내용을 입력해주세요."
            reviewTextView.textColor = UIColor.lightGray
            }
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

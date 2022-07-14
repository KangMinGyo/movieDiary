//
//  ReviewViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/01.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var bestButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var notBadButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    var movieName : String = ""
    var movieInfo : String = ""
    var star : Float = 0.0
    var eval : String = ""
    
    var buttonCheak : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCheak = 0
        print(buttonCheak)
        self.movieNameLabel.text = movieName
        
        reviewTextView.delegate = self
        reviewTextView.text = "내용을 입력하세요."
        reviewTextView.textColor = UIColor.lightGray
        
        cosmosView.didFinishTouchingCosmos = { rating in
            self.cosmosView.text = String(Int(Float(rating) + Float(rating)))
            self.star = Float(rating)
        }
        
        bestButton.layer.cornerRadius = 0.2 * bestButton.bounds.size.width
        bestButton.clipsToBounds = true
        goodButton.layer.cornerRadius = 0.2 * goodButton.bounds.size.width
        goodButton.clipsToBounds = true
        notBadButton.layer.cornerRadius = 0.2 * notBadButton.bounds.size.width
        notBadButton.clipsToBounds = true
        badButton.layer.cornerRadius = 0.2 * badButton.bounds.size.width
        badButton.clipsToBounds = true
    }
    
    // MARK: - 메모 입력

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let review = reviewTextView.text, review.count > 0 else {
            //내용 입력 안하면 alert
            let alert = UIAlertController(title: "잠깐!", message: "나의 한줄평을 입력해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        //나의 평가 안하면 alert
        if buttonCheak <= 0 {
            let alert = UIAlertController(title: "잠깐!", message: "나의 평가를 해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
            //데이터 전달
            DataManager.shared.addNewReview(review, movieName, movieInfo, star, eval)
        self.navigationController?.popToRootViewController(animated: true)
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
    
    // MARK: - 나의 평가
    
    @IBAction func evalButton(_ sender: UIButton) {
        bestButton.isSelected = false
        goodButton.isSelected = false
        notBadButton.isSelected = false
        badButton.isSelected = false
        sender.isSelected = true
        buttonCheak += 1
        
        eval = sender.currentTitle!
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

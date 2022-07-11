//
//  RecordDetailsViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/03.
//

import UIKit
import Cosmos

class RecordDetailsViewController: UIViewController {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReview: UITextView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    var movieNm : String = ""
    var movieRv : String = ""
    var star : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieName.text = movieNm
        movieReview.text = movieRv
        print(star)
        
        cosmosView.rating = Double(star)

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

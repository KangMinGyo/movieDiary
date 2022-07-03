//
//  ReviewViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/01.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    var movieName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movieName)
        self.movieNameLabel.text = movieName
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

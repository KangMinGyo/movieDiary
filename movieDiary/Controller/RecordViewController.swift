//
//  RecordViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/03.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        return f
    }()
    
    @IBOutlet weak var RecordTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.movieReviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        let target = DataManager.shared.movieReviewList[indexPath.row]
        cell.movieName.text = target.title
        cell.movieInfo.text = target.movieInfo
        cell.recordDate.text = formatter.string(for: target.insertDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = DataManager.shared.movieReviewList[indexPath.row]
            DataManager.shared.deleteReview(target)
            
            DataManager.shared.movieReviewList.remove(at: indexPath.row)
            RecordTableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchReview()
        RecordTableView.reloadData()
        
        if DataManager.shared.movieReviewList.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataManager.shared.movieReviewList.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }

    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reviewSegue" {
            if let vc = segue.destination as? RecordDetailsViewController {
                if let selectdeIndex =
                    self.RecordTableView.indexPathForSelectedRow?.row {
                    vc.movieNm = DataManager.shared.movieReviewList[selectdeIndex].title ?? ""
                    vc.movieRv = DataManager.shared.movieReviewList[selectdeIndex].content ?? ""
                    vc.star = DataManager.shared.movieReviewList[selectdeIndex].star
                    vc.eval = DataManager.shared.movieReviewList[selectdeIndex].eval ?? ""
                }
            }
        }
    }

}

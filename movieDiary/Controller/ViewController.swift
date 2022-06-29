//
//  ViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movieData : MovieData?
    
    let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=60c9b995596ead85ff6e59a8d3725e72&targetDt=20220628"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getData()
    }
    
    func getData() {
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieData.self, from: JSONdata)
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].rank)
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].openDt)
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].audiAcc)
                        self.movieData = decodedData
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        cell.movieRank.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].rank
        cell.releaseDate.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].openDt
        cell.audiNum.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }


}


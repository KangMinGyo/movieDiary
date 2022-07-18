//
//  ViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movieName : [String] = []
    
    var movieData : MovieData?
    var moviePosterData : MoviePosterData?
    
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=60c9b995596ead85ff6e59a8d3725e72&targetDt="
    
    var moviePosterURL = "https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieURL += yesterdayDate()
        self.getData()
        
        let searchMovieName = "탑건: 매버릭"
        moviePosterURL += searchMovieName
        moviePosterURL = moviePosterURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.posterGetData()
    }
    
    //어제 날짜 구하기
    func yesterdayDate() -> String {
        let now = Date()
        let yesterday = now.addingTimeInterval(3600 * -24)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let yesterdayData = formatter.string(from: yesterday)
        
        return yesterdayData
    }
    
    //JSON 데이터 가져오기
    func getData() {
        guard let url = URL(string: movieURL) else { return }
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
    
    //Movie Poster JSON 데이터 가져오기
    func posterGetData() {
        guard let url = URL(string: moviePosterURL) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MoviePosterData.self, from: JSONdata)
                        self.moviePosterData = decodedData
                        print("여기")
                        print(self.moviePosterData!.results[0].poster_path)
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
    
    //TableView 관련
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        var posterURL = "https://image.tmdb.org/t/p/original/"
        posterURL += String(moviePosterData?.results[0].poster_path ?? "")
        cell.moviePoster.image = UIImage(url: URL(string: posterURL))
        
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        cell.movieRank.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].rank
        cell.releaseDate.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].openDt
        cell.audiNum.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc
        return cell
    }
    
}

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}

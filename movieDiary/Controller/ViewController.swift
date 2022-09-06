//
//  ViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/27.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movieNameArray: [String] = []
    
    var movieData : MovieData?
    var moviePosterData: MoviePosterData?
    
    var urlArray : [String] = []
   
    var session: URLSession = URLSession.shared

    
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=60c9b995596ead85ff6e59a8d3725e72&targetDt="
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieURL += yesterdayDate()
        self.getData()
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
                        
                        for i in 0..<10 {
                            self.movieNameArray.append(self.movieData?.boxOfficeResult.dailyBoxOfficeList[i].movieNm ?? "")
                        }
                        
                        for item in self.movieNameArray {
                            var posterURL = ""
                            posterURL = self.FindMoviePosterURL(item)
                            self.getPosterURLData(posterURL)
                            
                        }
                        
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
    func getPosterURLData(_ url: String) {
        guard let url = URL(string: url) else { return }
//        print("url\(url)")
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let JSONdata = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(MoviePosterData.self, from: JSONdata) //여기서 문제네
                    self.moviePosterData = decodedData
                    
                    let check = self.moviePosterData?.results.isEmpty
                    if check == false {
                        print("kjsj: \(self.moviePosterData?.results[0].poster_path)")
                        let backPosterURL = self.moviePosterData?.results[0].poster_path
                        let lastURL = self.getPosterImageURL(backPosterURL!)
                        self.urlArray.append(lastURL)
                    } else {
                        print("없지롱")
                        self.urlArray.append("")
                    }
                    print("urlArray\(self.urlArray)")
                } catch {
                    print(error)
                    self.urlArray.append("")
                }
            }
        }
        task.resume()
    }
    
    func FindMoviePosterURL(_ movieName : String) -> String {
        let searchMovieName = movieName
        var moviePosterURL = "https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query="

        moviePosterURL += searchMovieName
        moviePosterURL = moviePosterURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return moviePosterURL
    }
    
    func getPosterImageURL(_ posterDataURL: String) -> String {
        var posterURL = "https://image.tmdb.org/t/p/original"
        posterURL += String(posterDataURL)
        return posterURL
    }
    
    //TableView 관련
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let boxofficeInfo = self.movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row]
        cell.moviePoster.image = UIImage(named: "loading.png")
        cell.moviePoster.contentMode = .center
        cell.movieName.text = boxofficeInfo?.movieNm
        cell.movieRank.text = boxofficeInfo?.rank
        cell.releaseDate.text = boxofficeInfo?.openDt
        cell.audiNum.text = boxofficeInfo?.audiAcc
        
            let secondsToDelay = 2.4
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        let imgUrl = URL(string: self.urlArray[indexPath.row])
                        cell.moviePoster.kf.setImage(with: imgUrl)
                        cell.moviePoster.contentMode = .scaleAspectFit
                }

            }
        }
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
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
            // Determine the scale factor that preserves aspect ratio
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            let scaleFactor = min(widthRatio, heightRatio)
            
            // Compute the new image size that preserves aspect ratio
            let scaledImageSize = CGSize(
                width: size.width * scaleFactor,
                height: size.height * scaleFactor
            )

            // Draw and return the resized UIImage
            let renderer = UIGraphicsImageRenderer(
                size: scaledImageSize
            )

            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(
                    origin: .zero,
                    size: scaledImageSize
                ))
            }
            
            return scaledImage
        }
}

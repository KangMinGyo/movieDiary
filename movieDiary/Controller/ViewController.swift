//
//  ViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/27.
//

import UIKit

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
        // Do any additional setup after loading the view.
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
                        //print(decodedData)
                        self.movieData = decodedData
                        
                        for i in 0..<10 {
                            self.movieNameArray.append(self.movieData?.boxOfficeResult.dailyBoxOfficeList[i].movieNm ?? "")
                        }
                        
                        for item in self.movieNameArray {
                            var posterURL = ""
//                            print(item)
                            posterURL = self.FindMoviePosterURL(item)
                            //print("posterURL\(posterURL)")
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
        //print("url\(url)") 여기까진 됨
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let JSONdata = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(MoviePosterData.self, from: JSONdata) //여기서 문제네
//                    print("decodedData \(decodedData)")
                    self.moviePosterData = decodedData
//
//                    print("moviePosterData\(self.moviePosterData)")
                    
                    if let backPosterURL = self.moviePosterData?.results[0].poster_path {
                        var lastURL = self.getPosterImageURL(backPosterURL)
                        self.urlArray.append(lastURL)
                    } else {
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
//        print(posterURL)
        return posterURL
    }
    
    //TableView 관련
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.movieData?.boxOfficeResult.dailyBoxOfficeList.count ?? 5
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let boxofficeInfo = self.movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row]
        cell.moviePoster.image = nil
        
        cell.movieName.text = boxofficeInfo?.movieNm
        cell.movieRank.text = boxofficeInfo?.rank
        cell.releaseDate.text = boxofficeInfo?.openDt
        cell.audiNum.text = boxofficeInfo?.audiAcc
        
//
//        var posterURLData: String?
//        let imageURL: String?
//
//        DispatchQueue.global().async {
//            if let movieTitle = boxofficeInfo?.movieNm {
//                posterURLData = self.FindMoviePosterURL(movieTitle)
//            } else {
//                posterURLData = self.FindMoviePosterURL("")
//            }
//
//            print(posterURLData)
//
//            if let url = posterURLData {
//                print("존재함?")
//                self.getPosterURLData(url)
//            } else {
//                print("tlqkf")
//            }
//            print("posterURLdata")
//        }
//
//        if let url = urlArray[indexPath.row] {
//            imageURL = getPosterImageURL(url)
//            urlArray.append(imageURL ?? "")
            
//            print("urlArray:\(urlArray)")
            let secondsToDelay = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.moviePoster.image = UIImage(url: URL(string: self.urlArray[indexPath.row]))
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
    func resize(newWidth: CGFloat) -> UIImage {
            let scale = newWidth / self.size.width
            let newHeight = self.size.height * scale

            let size = CGSize(width: newWidth, height: newHeight)
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image { context in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
            
            print("화면 배율: \(UIScreen.main.scale)")// 배수
            print("origin: \(self), resize: \(renderImage)")
            return renderImage
        }
    
}
//
//postrtURL 탑건 https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%ED%83%91%EA%B1%B4:%20%EB%A7%A4%EB%B2%84%EB%A6%AD
//postrtURL 토르
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%ED%86%A0%EB%A5%B4:%20%EB%9F%AC%EB%B8%8C%20%EC%95%A4%20%EC%8D%AC%EB%8D%94
//postrtURL 해결
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%ED%97%A4%EC%96%B4%EC%A7%88%20%EA%B2%B0%EC%8B%AC
//postrtURL 코난
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EB%AA%85%ED%83%90%EC%A0%95%20%EC%BD%94%EB%82%9C:%20%ED%95%A0%EB%A1%9C%EC%9C%88%EC%9D%98%20%EC%8B%A0%EB%B6%80
//postrtURL 앨비스
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EC%97%98%EB%B9%84%EC%8A%A4
//postrtURL 범죄도시
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EB%B2%94%EC%A3%84%EB%8F%84%EC%8B%9C%202
//postrtURL
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EB%8D%94%20%ED%82%AC%EB%9F%AC:%20%EC%A3%BD%EC%96%B4%EB%8F%84%20%EB%90%98%EB%8A%94%20%EC%95%84%EC%9D%B4
//postrtURL
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EB%92%A4%ED%8B%80%EB%A6%B0%20%EC%A7%91
//postrtURL
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%EA%B7%B8%EB%A0%88%EC%9D%B4%20%EB%A7%A8
//postrtURL
//https://api.themoviedb.org/3/search/movie?api_key=ab318418ee513b352deb4c9ab21f7ed7&language=ko&page=1&include_adult=false&region=KR&query=%ED%95%9C%EC%82%B0:%20%EC%9A%A9%EC%9D%98%20%EC%B6%9C%ED%98%84

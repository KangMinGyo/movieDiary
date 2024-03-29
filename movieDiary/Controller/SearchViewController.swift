//
//  ReviewViewController.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/30.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var movieSearch : MovieSaerch?
    var movieSearchURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=60c9b995596ead85ff6e59a8d3725e72&movieNm="
    
    var movieName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationController?.isNavigationBarHidden = true
        self.getData()
    }
    
    func getData() {
        guard let url = URL(string: movieSearchURL) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieSaerch.self, from: JSONdata)
                        self.movieSearch = decodedData
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movieSearchURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=60c9b995596ead85ff6e59a8d3725e72&movieNm="
        let searchMovieName = searchBar.text
        movieSearchURL += searchMovieName!
        movieSearchURL = movieSearchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(movieSearchURL)
        self.getData()
        
        //검색 완료시 키보드 내리기
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearch?.movieListResult.movieList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.movieName.text = movieSearch?.movieListResult.movieList[indexPath.row].movieNm
        cell.movieInfo.text = movieSearch?.movieListResult.movieList[indexPath.row].movieInfo
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            if let vc = segue.destination as? ReviewViewController {
                if let selectdeIndex =
                    self.searchTableView.indexPathForSelectedRow?.row {
                    vc.movieName = movieSearch?.movieListResult.movieList[selectdeIndex].movieNm ?? ""
                    vc.movieInfo = movieSearch?.movieListResult.movieList[selectdeIndex].movieInfo ?? ""
                }
            }
        }
    }
}

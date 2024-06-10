//
//  TrendViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/10/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

struct TrendMovieResponse: Decodable {
    let page: Int
    let results: [TrendMovie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TrendMovie: Decodable {
    let title: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    static let genreDict: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western",
    ]
    
    var genreText: String {
        var ret = ""
        for genreId in genreIds {
            if let genre = TrendMovie.genreDict[genreId] {
                ret += "#\(genre) "
            }
        }
        return ret
    }
    
    var dateString: String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: releaseDate)!
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    var imageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
    
    var score: String {
        return String(format: "%.1f", voteAverage)
    }
}

class TrendViewController: UIViewController {
    
    let tableView = UITableView()
    
    var trendMovieResult: TrendMovieResponse? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureTableView()
        callRequest()
    }
    
    func configureNavigationBar() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "list.triangle"),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func menuButtonTapped() {
        print(#function)
    }
    
    @objc func searchButtonTapped() {
        print(#function)
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
    
    func callRequest() {
        let url = APIURL.weekMovieTrendURL
        
        let param: Parameters = [
            "language" : "en-US"
        ]
        
        let header: HTTPHeaders = [
            "accept" : "application/json",
            "Authorization" : APIKey.tmdbAccessToken
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: param,
            headers: header
        ).responseDecodable(of: TrendMovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                self.trendMovieResult = value
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendMovieResult?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        
        let data = trendMovieResult?.results[indexPath.row]
        cell.configureCell(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

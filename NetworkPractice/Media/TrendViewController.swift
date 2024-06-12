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

enum TimeWindow: String {
    case week
    case day
}

class TrendViewController: UIViewController {
    
    let tableView = UITableView()
    
    var movieResult: MovieResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var timeWindow: TimeWindow = .day {
        didSet {
            navigationItem.title = timeWindow.rawValue
            callRequest()
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
        navigationItem.title = timeWindow.rawValue
        
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
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    @objc func menuButtonTapped() {
        print(#function)
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let day = UIAlertAction(title: "Day", style: .default) { _ in
            self.timeWindow = .day
        }
        
        let week = UIAlertAction(title: "Week", style: .default){ _ in
            self.timeWindow = .week
        }
        
        alert.addAction(day)
        alert.addAction(week)
        
        present(alert, animated: true)
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
        
        tableView.rowHeight = 500
        tableView.separatorStyle = .none
        
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
    
    func callRequest() {
        let url = APIURL.weekMovieTrendURL + timeWindow.rawValue
        
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
        ).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("trendMovieResult Success")
                self.movieResult = value
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResult?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        
        let data = movieResult?.results[indexPath.row]
        cell.configureCell(data)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TrendDetailViewController()
        vc.movie = movieResult?.results[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

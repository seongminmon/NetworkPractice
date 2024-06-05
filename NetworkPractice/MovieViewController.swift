//
//  MovieViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit
import SnapKit
import Alamofire

struct MovieResult: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [Movie]
}

struct Movie: Codable {
    let rank, movieNm, openDt: String
}

class MovieViewController: UIViewController {

    let backgroundImageView = UIImageView()
    let textField = UITextField()
    let separator = UIView()
    let searchButton = UIButton()
    let tableView = UITableView()
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        
        callRequest("20240604")
    }
    
    func configureHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(textField)
        view.addSubview(separator)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.trailing.equalTo(searchButton.snp.leading).offset(-16)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.leading.trailing.equalTo(textField)
            make.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.tintColor = .white
        textField.placeholder = "날짜를 입력하세요"
        
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = .white
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
        separator.backgroundColor = .white
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    @objc func searchButtonClicked() {
        callRequest(textField.text!)
        view.endEditing(true)
    }
    
    func callRequest(_ dateString: String) {
        let url = APIURL.movieURL
        AF.request(url + dateString).responseDecodable(of: MovieResult.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                self.movieList = value.boxOfficeResult.dailyBoxOfficeList
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let movie = movieList[indexPath.row]
        cell.numberLabel.text = movie.rank
        cell.titleLabel.text = movie.movieNm
        cell.dateLabel.text = movie.openDt
        
        cell.backgroundColor = .clear
        return cell
    }
}

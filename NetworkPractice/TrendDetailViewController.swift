//
//  TrendDetailViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/10/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

// MARK: - quicktype.io
struct Credit: Codable {
    let id: Int
    let cast, crew: [Cast]
}

struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: String
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

enum Sections: Int, CaseIterable {
    case main
    case overview
    case cast
    case crew
    
    var headerTitle: String {
        switch self {
        case .main: ""
        case .overview: "OverView"
        case .cast: "Cast"
        case .crew: "Crew"
        }
    }
}

class TrendDetailViewController: UIViewController {

    var movie: TrendMovie?  // 이전 화면에서 전달
    var credit: Credit?     // 네트워크로 받아오기
    
//    let overviewLabel = UILabel()
//    let descriptionLabel = UILabel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(Sections.allCases.count)
//        print(movie)
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        callRequest()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "출연/제작"
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MainCreditCell.self, forCellReuseIdentifier: MainCreditCell.identifier)
    }
    
    func callRequest() {
        guard let movie else { return }
        
        APIURL.movieId = movie.id
        let url = APIURL.movieCreditURL

        let header: HTTPHeaders = [
            "accept" : "application/json",
            "Authorization" : APIKey.tmdbAccessToken
        ]
        
        AF.request(
            url,
            method: .get,
            headers: header
        ).responseDecodable(of: Credit.self) { response in
            switch response.result {
            case .success(let value):
                print("Credit Success")
//                dump(value)
                self.credit = value
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension TrendDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return Sections.allCases.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        switch section {
        case 0: return 1
        default: return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        switch indexPath.section {
        case 0: 
            let cell = tableView.dequeueReusableCell(withIdentifier: MainCreditCell.identifier, for: indexPath) as! MainCreditCell
            let data = movie
            cell.configureCell(data)
            return cell
            
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .blue
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 200
        default: return 40
        }
    }
}

class MainCreditCell: UITableViewCell {
    
    let backgroundImageView = UIImageView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
//            make.top.greaterThanOrEqualToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(posterImageView.snp.top).offset(-8)
            make.height.equalTo(40)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = .gray
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .gray
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: TrendMovie?) {
        guard let data else { return }
        backgroundImageView.kf.setImage(with: data.backdropImageURL)
        posterImageView.kf.setImage(with: data.posterImageURL)
        titleLabel.text = data.title
    }
}

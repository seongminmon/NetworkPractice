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

struct Credit: Decodable {
    let id: Int
    let cast, crew: [Cast]
}

struct Cast: Decodable {
    let profilePath: String?
    let name: String
    let character: String?
    let knownForDepartment: String
    
    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case name
        case character
        case knownForDepartment = "known_for_department"
    }
    
    var posterImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath ?? "")")
    }
}

enum Sections: Int, CaseIterable {
    case main
    case overview
    case cast
    case crew
    
    var headerTitle: String? {
        switch self {
        case .main: nil
        case .overview: "OverView"
        case .cast: "Cast"
        case .crew: "Crew"
        }
    }
}

class TrendDetailViewController: UIViewController {
    
    var movie: Movie?       // 이전 화면에서 전달
    var credit: Credit?     // 네트워크로 받아오기
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
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
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MainCreditCell.self, forCellReuseIdentifier: MainCreditCell.identifier)
        tableView.register(OverViewCreditCell.self, forCellReuseIdentifier: OverViewCreditCell.identifier)
        tableView.register(CastAndCrewCreditCell.self, forCellReuseIdentifier: CastAndCrewCreditCell.identifier)
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
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: nil
        case 1: Sections.overview.headerTitle
        case 2: Sections.cast.headerTitle
        case 3: Sections.crew.headerTitle
        default: nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: 1
        case 1: 1
        case 2: credit?.cast.count ?? 0
        case 3: credit?.crew.count ?? 0
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainCreditCell.identifier, for: indexPath) as! MainCreditCell
            let data = movie
            cell.configureCell(data)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: OverViewCreditCell.identifier, for: indexPath) as! OverViewCreditCell
            let data = movie?.overview
            cell.configureCell(data)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastAndCrewCreditCell.identifier, for: indexPath) as! CastAndCrewCreditCell
            let data = credit?.cast[indexPath.row]
            cell.configureCellWithCast(data)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastAndCrewCreditCell.identifier, for: indexPath) as! CastAndCrewCreditCell
            let data = credit?.crew[indexPath.row]
            cell.configureCellWithCrew(data)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 200
        case 1: return 60
        case 2: return 80
        default: return 80
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
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
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
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: Movie?) {
        guard let data else { return }
        backgroundImageView.kf.setImage(with: data.backdropImageURL)
        posterImageView.kf.setImage(with: data.posterImageURL)
        titleLabel.text = data.title
    }
}

class OverViewCreditCell: UITableViewCell {
    
    let descriptionLabel = UILabel()
    let seeMoreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(seeMoreButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        
        seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        seeMoreButton.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: String?) {
        descriptionLabel.text = data
    }
}

class CastAndCrewCreditCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(profileImageView.snp.height).multipliedBy(0.8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.height.equalTo(30)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .gray
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        detailLabel.font = .systemFont(ofSize: 13)
        detailLabel.textColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWithCast(_ data: Cast?) {
        guard let data else { return }
        profileImageView.kf.setImage(with: data.posterImageURL)
        nameLabel.text = data.name
        detailLabel.text = data.character
    }
    
    func configureCellWithCrew(_ data: Cast?) {
        guard let data else { return }
        profileImageView.kf.setImage(with: data.posterImageURL)
        nameLabel.text = data.name
        detailLabel.text = data.knownForDepartment
    }
}

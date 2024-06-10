//
//  TrendDetailViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/10/24.
//

import UIKit
import Alamofire
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

class TrendDetailViewController: UIViewController {

    var movie: TrendMovie?  // 이전 화면에서 전달
    var credit: Credit?     // 네트워크로 받아오기
    
    // TODO: - layout, 테이블뷰 구현, 네트워크로 받아온 정보 보이기
    
    let backgroundImageView = UIImageView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    
    let overviewLabel = UILabel()
    let separator = UIView()
    let descriptionLabel = UILabel()
    
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "출연/제작"
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureUI() {
        
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
                dump(value)
                self.credit = value
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

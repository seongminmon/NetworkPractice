//
//  MovieSearchViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/11/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class MovieSearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    // page 1당 20개씩 가져옴
    // 종료 조건: page < movieResponse.totalPages
    var movieResponse: MovieResponse = MovieResponse(page: 0, results: [], totalPages: 0, totalResults: 0)
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureView()
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        navigationItem.title = "영화 검색"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        
        // placeholder color
        let placeholder = "영화 제목을 검색해보세요"
        let attributedString = NSMutableAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        searchBar.searchTextField.attributedPlaceholder = attributedString
        // text color
        searchBar.searchTextField.textColor = .white
        // background color
        searchBar.barTintColor = .black
        // textfield color
        searchBar.searchTextField.backgroundColor = .darkGray
        // 커서 color
        searchBar.tintColor = .lightGray
        // icon color
        searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
    
    func configureView() {
        searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(MovieSearchCollectionViewCell.self, forCellWithReuseIdentifier: MovieSearchCollectionViewCell.identifier)
    }
    
    func callRequest(query: String) {
        let url = APIURL.movieSearchURL
        let param: Parameters = [
            "query" : query,
            "page" : page
        ]
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "Authorization" : APIKey.tmdbAccessToken
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: param,
            headers: headers
        ).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                
                if self.page == 1 {
                    // 새로운 검색일땐 교체
                    self.movieResponse = value
                } else {
                    // 같은 검색일땐 추가
                    self.movieResponse.results.append(contentsOf: value.results)
                }
                
                // 테이블뷰 갱신
                self.collectionView.reloadData()
                
                // 새로운 검색일때 스크롤 상단으로 올리기
                if self.page == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 페이지 초기화
        page = 1
        // 검색 (네트워크)
        callRequest(query: searchBar.text!)
    }
}

extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResponse.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSearchCollectionViewCell.identifier, for: indexPath) as! MovieSearchCollectionViewCell
        let data = movieResponse.results[indexPath.item]
        cell.configureCell(data)
        return cell
    }
}

extension MovieSearchViewController: UICollectionViewDataSourcePrefetching {
    // 페이지네이션
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function, movieResponse.results.count)
        
        for indexPath in indexPaths {
            if movieResponse.results.count - 2 == indexPath.item 
                && page < movieResponse.totalPages {
                page += 1
                callRequest(query: searchBar.text!)
            }
        }
    }
}

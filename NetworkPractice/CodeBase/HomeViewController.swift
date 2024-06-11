//
//  HomeViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let imageList: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
    ]
    
    let mainView = UIView()
    let mainImageView = UIImageView()
    let descriptionLabel = UILabel()
    let playButton = UIButton()
    let likeButton = UIButton()
    
    let contentsLabel = UILabel()
    let posterStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigation() {
        navigationItem.title = "유저님"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureHierarchy() {
        mainView.addSubview(mainImageView)
        mainView.addSubview(playButton)
        mainView.addSubview(likeButton)
        mainView.addSubview(descriptionLabel)
        posterStackView.addArrangedSubview(makeRandomPosterView())
        posterStackView.addArrangedSubview(makeRandomPosterView())
        posterStackView.addArrangedSubview(makeRandomPosterView())
        
        view.addSubview(mainView)
        view.addSubview(contentsLabel)
        view.addSubview(posterStackView)
    }
    
    func configureLayout() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(mainView.snp.width).multipliedBy(1.4)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(12)
            make.size.equalTo(playButton)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-12)
            make.height.equalTo(40)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(mainView.snp.bottom).offset(4)
        }
        
        posterStackView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        mainView.backgroundColor = .blue
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        
        mainImageView.image = imageList.randomElement()
        mainView.contentMode = .scaleAspectFill
        
        descriptionLabel.text = "응원하고픈 · 흥미진진 · 사극 · 전투 · 한국 작품"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.setTitle("재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.tintColor = .black
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 10
        
        likeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        likeButton.setTitle("내가 찜한 리스트", for: .normal)
        likeButton.tintColor = .white
        likeButton.backgroundColor = .darkGray
        likeButton.layer.cornerRadius = 10
        
        contentsLabel.text = "지금 뜨는 콘텐츠"
        contentsLabel.textColor = .white
        
        posterStackView.axis = .horizontal
        posterStackView.alignment = .fill
        posterStackView.distribution = .fillEqually
        posterStackView.spacing = 8
    }
    
    func makeRandomPosterView() -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        let mainImageView = UIImageView()
        mainImageView.image = imageList.randomElement()
        
        let topImageView = UIImageView()
        topImageView.image = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        topImageView.tintColor = .red
        topImageView.isHidden = Bool.random()
        
        let bottomImageView = UIImageView()
        bottomImageView.image = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        bottomImageView.tintColor = .red
        bottomImageView.isHidden = Bool.random()
        
        view.addSubview(mainImageView)
        view.addSubview(topImageView)
        view.addSubview(bottomImageView)
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.size.equalTo(30)
        }
        
        bottomImageView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        
        return view
    }

}

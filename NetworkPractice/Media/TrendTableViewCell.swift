//
//  TrendTableViewCell.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class TrendTableViewCell: UITableViewCell {
    
    let dateLabel = UILabel()
    let genreLabel = UILabel()
    
    let shadowView = UIView()
    let containerView = UIView()
    
    let posterImageView = UIImageView()
    let clipButton = UIButton()
    
    let rateLabel = UILabel()
    let scoreLabel = UILabel()
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let separator = UIView()
    let detailLabel = UILabel()
    let detailImageView = UIImageView()
    let descriptionView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(genreLabel)
        
        descriptionView.addSubview(titleLabel)
        descriptionView.addSubview(descriptionLabel)
        descriptionView.addSubview(separator)
        descriptionView.addSubview(detailLabel)
        descriptionView.addSubview(detailImageView)
        
        containerView.addSubview(posterImageView)
        containerView.addSubview(clipButton)
        containerView.addSubview(rateLabel)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(descriptionView)
        
        shadowView.addSubview(containerView)
        contentView.addSubview(shadowView)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(descriptionView.snp.top)
        }
        
        clipButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(posterImageView.snp.bottom).inset(16)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing)
            make.top.equalTo(rateLabel)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(detailImageView.snp.leading).offset(-16)
            make.bottom.equalToSuperview().inset(8)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(detailImageView.snp.height)
        }
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        
        genreLabel.font = .boldSystemFont(ofSize: 15)
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.9
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .gray
        
        descriptionView.backgroundColor = .white
        
        clipButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        clipButton.tintColor = .black
        clipButton.backgroundColor = .white
        clipButton.layer.cornerRadius = 15
        
        rateLabel.text = "평점"
        rateLabel.font = .systemFont(ofSize: 14)
        rateLabel.textColor = .white
        rateLabel.backgroundColor = .systemIndigo
        rateLabel.textAlignment = .center
        
        scoreLabel.font = .systemFont(ofSize: 14)
        scoreLabel.textColor = .systemIndigo
        scoreLabel.backgroundColor = .white
        scoreLabel.textAlignment = .center
        
        separator.backgroundColor = .black
        
        detailLabel.text = "자세히 보기"
        detailLabel.font = .systemFont(ofSize: 14)
        
        detailImageView.image = UIImage(systemName: "chevron.right")
        detailImageView.tintColor = .black
    }
    
    func configureCell(_ data: TrendMovie?) {
        guard let data else { return }
        dateLabel.text = data.dateString
        genreLabel.text = data.genreText
        posterImageView.kf.setImage(with: data.posterImageURL)
        scoreLabel.text = data.score
        titleLabel.text = data.title
        descriptionLabel.text = data.overview
    }
}

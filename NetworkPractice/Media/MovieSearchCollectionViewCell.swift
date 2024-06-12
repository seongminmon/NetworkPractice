//
//  MovieSearchCollectionViewCell.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/11/24.
//

import UIKit
import Kingfisher
import SnapKit

class MovieSearchCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = UIImageView()
//    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        profileImageView.backgroundColor = .gray
        
        contentView.addSubview(profileImageView)
//        contentView.addSubview(titleLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.bottom.horizontalEdges.equalToSuperview().inset(8)
//            make.height.equalTo(30)
//        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        
//        titleLabel.font = .systemFont(ofSize: 15, weight: .heavy)
//        titleLabel.textColor = .white
//        titleLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: Movie) {
        profileImageView.kf.setImage(with: data.posterImageURL)
//        titleLabel.text = data.title
    }
}

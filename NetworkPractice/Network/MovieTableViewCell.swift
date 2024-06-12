//
//  MovieTableViewCell.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }
    
    func configureLayout() {
        numberLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalTo(numberLabel.snp.trailing).offset(4)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
        }
    }
    
    func configureUI() {
        numberLabel.font = .boldSystemFont(ofSize: 15)
        numberLabel.textAlignment = .center
        numberLabel.textColor = .black
        numberLabel.backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .white
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .right
    }
    
    func configureCell(_ boxOffice: BoxOffice) {
        numberLabel.text = boxOffice.rank
        titleLabel.text = boxOffice.movieNm
        dateLabel.text = boxOffice.openDt
    }
    
}

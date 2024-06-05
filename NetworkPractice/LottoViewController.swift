//
//  LottoViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit
import Alamofire
import SnapKit

struct Lotto: Decodable {
    let totSellamnt: Int
    let returnValue: String
    let drwNoDate: String
    let firstWinamnt: Int
    let firstPrzwnerCo: Int
    let bnusNo: Int
    let firstAccumamnt: Int
    
    let drwNo: Int
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    
    var numberText: String {
        return "\(drwtNo1) \(drwtNo2) \(drwtNo3) \(drwtNo4) \(drwtNo5) \(drwtNo6) + \(bnusNo)"
    }
    
    var resultText: String {
        return "1등 당첨금 \(firstWinamnt.formatted())원 (당첨 복권수 \(firstPrzwnerCo)개)"
    }
}

class LottoViewController: UIViewController {

    lazy var url = APIURL.lottoURL
    
    let textField = UITextField()
    let searchButton = UIButton()
    let numberLabel = UILabel()
    let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
        search(numberString: "1100")
    }
    
    func configureNavigation() {
        navigationItem.title = "로또"
    }
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(numberLabel)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        textField.placeholder = "회차를 입력해보세요"
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        
        searchButton.setTitle("검색하기", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 10
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
        numberLabel.font = .boldSystemFont(ofSize: 20)
        numberLabel.textAlignment = .center
        
        resultLabel.font = .systemFont(ofSize: 18)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
    }
    
    @objc func searchButtonClicked() {
        search(numberString: textField.text!)
        view.endEditing(true)
    }
    
    func search(numberString: String) {
        AF.request(url + numberString).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let value):
                self.numberLabel.text = value.numberText
                self.resultLabel.text = value.resultText
                print(value)
            case .failure(let error):
                print(error)
                self.numberLabel.text = ""
                self.resultLabel.text = "오류 발생! 다시 입력해주세요"
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

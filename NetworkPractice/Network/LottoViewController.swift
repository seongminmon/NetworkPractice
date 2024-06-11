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
//    let totSellamnt: Int
//    let returnValue: String
//    let firstWinamnt: Int
//    let firstPrzwnerCo: Int
//    let firstAccumamnt: Int

    let drwNoDate: String
    let drwNo: Int
    
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    
    var dateText: String {
        return "\(drwNoDate) 추첨"
    }
    
    var turnText: String {
        return "\(drwNo)회"
    }
}

class LottoViewController: UIViewController {

    lazy var url = APIURL.lottoURL
    let numberList: [Int] = (1...1100).reversed()
    var lotto: Lotto?
    
    let textField = UITextField()
    let pickerView = UIPickerView()
    
    let guideLabel = UILabel()
    let dateLabel = UILabel()
    
    let separateView = UIView()
    
    let labelStackView = UIStackView()
    let turnLabel = UILabel()
    let resultLabel = UILabel()
    
    let numberStackView = UIStackView()
    let number1Label = UILabel()
    let number2Label = UILabel()
    let number3Label = UILabel()
    let number4Label = UILabel()
    let number5Label = UILabel()
    let number6Label = UILabel()
    let plusLabel = UILabel()
    let bonusnumberLabel = UILabel()
    
    let bonusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        textField.text = "\(numberList.first!)"
        search(numberString: "\(numberList.first!)")
    }
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(guideLabel)
        view.addSubview(dateLabel)
        view.addSubview(separateView)
        
        labelStackView.addArrangedSubview(turnLabel)
        labelStackView.addArrangedSubview(resultLabel)
        view.addSubview(labelStackView)
        
        numberStackView.addArrangedSubview(number1Label)
        numberStackView.addArrangedSubview(number2Label)
        numberStackView.addArrangedSubview(number3Label)
        numberStackView.addArrangedSubview(number4Label)
        numberStackView.addArrangedSubview(number5Label)
        numberStackView.addArrangedSubview(number6Label)
        numberStackView.addArrangedSubview(plusLabel)
        numberStackView.addArrangedSubview(bonusnumberLabel)
        view.addSubview(numberStackView)
        
        view.addSubview(bonusLabel)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        numberStackView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(numberStackView.snp.width).multipliedBy(1.0 / 8.0)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.top.equalTo(numberStackView.snp.bottom).offset(4)
            make.trailing.equalTo(numberStackView)
            make.height.equalTo(30)
        }
    }
    
    func configureUI() {
        textField.placeholder = "회차를 입력해보세요"
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.inputView = pickerView
        
        pickerView.delegate = self
        pickerView.dataSource = self
        // 초기 선택 항목 지정
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        guideLabel.text = "당첨번호 안내"
        guideLabel.font = .systemFont(ofSize: 16)
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .right
        dateLabel.textColor = .lightGray
        
        separateView.backgroundColor = .lightGray
        
        labelStackView.axis = .horizontal
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = 4
        
        turnLabel.font = .boldSystemFont(ofSize: 24)
        turnLabel.textColor = .random()
        
        resultLabel.text = "당첨결과"
        resultLabel.font = .systemFont(ofSize: 24)
        
        numberStackView.axis = .horizontal
        numberStackView.alignment = .fill
        numberStackView.distribution = .fillEqually
        numberStackView.spacing = 4
        
        configureLabel(number1Label)
        configureLabel(number2Label)
        configureLabel(number3Label)
        configureLabel(number4Label)
        configureLabel(number5Label)
        configureLabel(number6Label)
        configureLabel(bonusnumberLabel)
        
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 18)
        plusLabel.textAlignment = .center
        
        bonusLabel.text = "보너스"
        bonusLabel.font = .systemFont(ofSize: 15)
    }
    
    func configureLabel(_ label: UILabel) {
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        
        label.backgroundColor = .random()
        label.clipsToBounds = true
        label.layer.cornerRadius = label.frame.width / 2
    }
    
    func reloadData() {
        guard let lotto else { return }
        
        dateLabel.text = lotto.dateText
        turnLabel.text = lotto.turnText
        turnLabel.textColor = .random()
        
        number1Label.text = "\(lotto.drwtNo1)"
        number2Label.text = "\(lotto.drwtNo2)"
        number3Label.text = "\(lotto.drwtNo3)"
        number4Label.text = "\(lotto.drwtNo4)"
        number5Label.text = "\(lotto.drwtNo5)"
        number6Label.text = "\(lotto.drwtNo6)"
        bonusnumberLabel.text = "\(lotto.bnusNo)"
        
        configureLabel(number1Label)
        configureLabel(number2Label)
        configureLabel(number3Label)
        configureLabel(number4Label)
        configureLabel(number5Label)
        configureLabel(number6Label)
        configureLabel(bonusnumberLabel)
    }

    func search(numberString: String) {
        AF.request(url + numberString).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                self.lotto = value
                self.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(numberList[row])"
        search(numberString: textField.text!)
    }
    
}

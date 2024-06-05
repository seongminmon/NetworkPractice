//
//  SignInViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/5/24.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nicknameTextField = UITextField()
    let locationTextField = UITextField()
    let recommandTextField = UITextField()
    let signInButton = UIButton()
    let additionalLabel = UILabel()
    let additionalSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(locationTextField)
        view.addSubview(recommandTextField)
        view.addSubview(signInButton)
        view.addSubview(additionalLabel)
        view.addSubview(additionalSwitch)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        recommandTextField.snp.makeConstraints { make in
            make.top.equalTo(locationTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(recommandTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        additionalLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }
        
        additionalSwitch.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        titleLabel.text = "MYFLIX"
        titleLabel.textColor = .red
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 32)

        configureTextField(emailTextField, placeholder: "이메일 주소 또는 전화번호")
        configureTextField(passwordTextField, placeholder: "비밀번호")
        configureTextField(nicknameTextField, placeholder: "닉네임")
        configureTextField(locationTextField, placeholder: "위치")
        configureTextField(recommandTextField, placeholder: "추천 코드 입력")
        
        signInButton.setTitle("회원가입", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        signInButton.backgroundColor = .white
        signInButton.layer.cornerRadius = 10
        
        additionalLabel.text = "추가 정보 입력"
        additionalLabel.font = .systemFont(ofSize: 18)
        additionalLabel.textColor = .white
        
        additionalSwitch.isOn = true
        additionalSwitch.onTintColor = .red
    }
    
    func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.backgroundColor = .gray
        textField.textColor = .white
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

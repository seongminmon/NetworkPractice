//
//  WeatherViewController.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/6/24.
//

import UIKit
import Alamofire
import SnapKit

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let humidity: Int
    
    var tempString: String {
        return "지금은 \(temp)°C에요"
    }
    
    var humidityString: String {
        return "\(humidity)%만큼 습해요"
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let description: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    
    var windStirng: String {
        return "\(speed)m/s의 바람이 불어요"
    }
}

class WeatherViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    let dateLabel = UILabel()
    
    let locationImageView = UIImageView()
    let locationLabel = UILabel()
    let shareButton = UIButton()
    let refreshButton = UIButton()
    lazy var mainStackView = UIStackView(arrangedSubviews: [locationImageView, locationLabel, shareButton, refreshButton])
    
    let temperatureLabel = UILabel()
    lazy var temperatureView = makeContainerView(temperatureLabel)
    
    let humidityLabel = UILabel()
    lazy var humidityView = makeContainerView(humidityLabel)
    
    let windLabel = UILabel()
    lazy var windView = makeContainerView(windLabel)
    
    let weatherImageView = UIImageView()
    
    let greetingLabel = UILabel()
    lazy var greetingView = makeContainerView(greetingLabel)
    
    var response: WeatherResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest()
    }
    
    func configureHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(dateLabel)
        
        view.addSubview(mainStackView)
        
        view.addSubview(temperatureView)
        view.addSubview(humidityView)
        view.addSubview(windView)
        view.addSubview(weatherImageView)
        view.addSubview(greetingView)
    }
    
    func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        temperatureView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        humidityView.snp.makeConstraints { make in
            make.top.equalTo(temperatureView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        windView.snp.makeConstraints { make in
            make.top.equalTo(humidityView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(windView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(150)
            make.width.equalTo(200)
        }
        
        greetingView.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func configureUI() {
        backgroundImageView.backgroundColor = .orange
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .white
        
        locationImageView.image = UIImage(systemName: "location.fill")
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.tintColor = .white
        
        locationLabel.font = .systemFont(ofSize: 24)
        locationLabel.textColor = .white
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .white
        
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .white
        
        configureLabel(temperatureLabel)
        configureLabel(humidityLabel)
        configureLabel(windLabel)
        
        weatherImageView.backgroundColor = .white
        weatherImageView.clipsToBounds = true
        weatherImageView.layer.cornerRadius = 10
        
        greetingLabel.text = "오늘도 행복한 하루 보내세요"
        configureLabel(greetingLabel)
    }
    
    func makeContainerView(_ label: UILabel) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        return containerView
    }
    
    func configureLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 15)
    }
    
    func reloadData() {
        dateLabel.text = dateString()
        locationLabel.text = "서울"
        temperatureLabel.text = response?.main.tempString
        humidityLabel.text = response?.main.humidityString
        windLabel.text = response?.wind.windStirng
    }
    
    func dateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 h시 m분"
        return formatter.string(from: date)
    }
    
    func callRequest() {
        let url = APIURL.weatherURL
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                self.response = value
                self.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

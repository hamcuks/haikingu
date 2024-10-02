//
//  OnboardingHealthAccessVC.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 30/09/24.
//

import UIKit
import SnapKit
import HealthKit

class OnboardingIntroductionVC: UIViewController {

    // UI Components
    let heartIconImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let continueButton = UIButton()

    // HealthKit store for requesting health data
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Heart Icon ImageView from Assets
        heartIconImageView.image = UIImage(named: "OnboardingIntroductionIcon") // Replace with your asset image name
        heartIconImageView.contentMode = .scaleAspectFit
        view.addSubview(heartIconImageView)

        // Setup Constraints for ImageView (264x264)
        heartIconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(254)  // Set width and height to 264
        }

        // Title Label
        titleLabel.text = "Welcome to your hiking companion"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        // Description Label
        descriptionLabel.text = "Hike smarter with group break management and heart rate monitoring for a safer journey."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // Allow Health Access Button
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor(red: 88/255, green: 113/255, blue: 96/255, alpha: 1.0)
        continueButton.layer.cornerRadius = 8
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(continueButton)

        // Setup Constraints
        setupConstraints()
    }

    func setupConstraints() {
        // Heart Icon Constraints
        heartIconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heartIconImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        // Description Label Constraints
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }

        // Allow Button Constraints
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    // Request HealthKit permissions
    @objc func continueButtonTapped() {
        let keyFeatureVC = OnboardingKeyFeatureVC()
        navigationController?.pushViewController(keyFeatureVC, animated: true)
    }
}

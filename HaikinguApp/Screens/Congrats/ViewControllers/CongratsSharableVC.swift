//
//  CongratsSharableVC.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 01/10/24.
//

import UIKit
import SnapKit

class CongratsSharableVC: UIViewController {
    
    init(workoutManager: WorkoutServiceIos?, destinationDetail: DestinationModel, restTakenTotal: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.workoutManager = workoutManager
        self.destinationDetail = destinationDetail
        self.restTakenTotal = restTakenTotal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var workoutManager: WorkoutServiceIos!
    var destinationDetail: DestinationModel!
    var restTakenTotal: Int!
    
    // UI Components
    let haikinguLabel = UILabel()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    
    let elevationStackView = UIStackView()
    let distanceStackView = UIStackView()
    let restStackView = UIStackView()
    
    let elevationArrowImageView = UIImageView()
    let elevationStatLabel = UILabel()
    
    let distanceArrowImageView = UIImageView()
    let distanceStatLabel = UILabel()
    
    let restArrowImageView = UIImageView()
    let restStatLabel = UILabel()
    
    let hikeImageView = UIImageView()
    
    var selectedImage: UIImage?
    
    func shareScreenshot() -> CGRect {
        print("Share button is hitted")
        let targetArea = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.height - 100))
        
        return targetArea
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupHaikinguLabel()
        setupTitleLabels()
        setupStatsViews()
        setupHikeImageView()
        setupLayout()
    }
    
    // MARK: - Setup UI
    
    private func setupHaikinguLabel() {
        // "Haikingu" Label
        haikinguLabel.text = "Haikingu"
        haikinguLabel.textColor = .lightGray
        haikinguLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.addSubview(haikinguLabel)
    }
    
    private func setupTitleLabels() {
        // Title Label
        titleLabel.text = "Great Job, Team!\n\(destinationDetail.name) Done in"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Time Label
        var elapsedTimeInterval = workoutManager.elapsedTimeInterval
        let hours = Int(elapsedTimeInterval) / 3600
        let minutes = (Int(elapsedTimeInterval) % 3600) / 60
        timeLabel.text = "\(hours) Hour \(minutes) Minutes"
        timeLabel.textColor = .black
        timeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.addSubview(timeLabel)
    }
    
    private func setupStatsViews() {
        // Elevation Gain
        elevationArrowImageView.image = UIImage(systemName: "arrow.up.right") // SF Symbol arrow
        elevationArrowImageView.tintColor = .gray
        elevationArrowImageView.contentMode = .scaleAspectFit
        
        elevationStatLabel.text = "\(destinationDetail.maxElevation) m\nElv. Gain"
        elevationStatLabel.font = UIFont.systemFont(ofSize: 16)
        elevationStatLabel.textColor = .darkGray
        elevationStatLabel.textAlignment = .left
        elevationStatLabel.numberOfLines = 2
        
        // Distance Hiked
        distanceArrowImageView.image = UIImage(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.filled.scurvepath") // SF Symbol arrow
        distanceArrowImageView.tintColor = .gray
        distanceArrowImageView.contentMode = .scaleAspectFit
        
        distanceStatLabel.text = "\(Int(workoutManager.distance)) m\nDistance"
        distanceStatLabel.font = UIFont.systemFont(ofSize: 16)
        distanceStatLabel.textColor = .darkGray
        distanceStatLabel.textAlignment = .left
        distanceStatLabel.numberOfLines = 2
        
        // Rest Taken
        restArrowImageView.image = UIImage(systemName: "figure.mind.and.body") // SF Symbol arrow
        restArrowImageView.tintColor = .gray
        restArrowImageView.contentMode = .scaleAspectFit
        
        restStatLabel.text = "\(restTakenTotal ?? 0)x\nRest Taken"
        restStatLabel.font = UIFont.systemFont(ofSize: 16)
        restStatLabel.textColor = .darkGray
        restStatLabel.textAlignment = .left
        restStatLabel.numberOfLines = 2
        
        // Setup Horizontal Stack Views for each stat with Arrow beside the label
        elevationStackView.axis = .horizontal
        elevationStackView.alignment = .center
        elevationStackView.spacing = 4
        elevationStackView.addArrangedSubview(elevationArrowImageView)
        elevationStackView.addArrangedSubview(elevationStatLabel)
        
        distanceStackView.axis = .horizontal
        distanceStackView.alignment = .center
        distanceStackView.spacing = 4
        distanceStackView.addArrangedSubview(distanceArrowImageView)
        distanceStackView.addArrangedSubview(distanceStatLabel)
        
        restStackView.axis = .horizontal
        restStackView.alignment = .center
        restStackView.spacing = 4
        restStackView.addArrangedSubview(restArrowImageView)
        restStackView.addArrangedSubview(restStatLabel)
        
        view.addSubview(elevationStackView)
        view.addSubview(distanceStackView)
        view.addSubview(restStackView)
    }
    
    private func setupHikeImageView() {
        hikeImageView.contentMode = .scaleAspectFill
        hikeImageView.clipsToBounds = true
        view.addSubview(hikeImageView)
        
        if let image = selectedImage {
            hikeImageView.image = image
        } else {
            hikeImageView.image = UIImage(named: "defaultHikeImage")
        }
    }
    
    // MARK: - Layout using SnapKit
    
    private func setupLayout() {
        // "Haikingu" Label
        haikinguLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        // Title Label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(haikinguLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        // Time Label
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        
        // Stats Layout with Arrow beside the Text
        let statsStackView = UIStackView(arrangedSubviews: [elevationStackView, distanceStackView, restStackView])
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 8
        view.addSubview(statsStackView)
        
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        // Hike Image
        hikeImageView.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300) // Adjust this to your desired height
            make.bottom.equalToSuperview().offset(-16) // Padding at the bottom
        }
    }
}

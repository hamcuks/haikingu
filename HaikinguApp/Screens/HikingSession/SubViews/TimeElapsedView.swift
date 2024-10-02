//
//  TimeElapsedView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class TimeElapsedView: UIView {
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 0
        vertical.distribution = .fillProportionally
        vertical.alignment = .center
        return vertical
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "Time Elapsed"
        label.textAlignment = .center
        return label
    }()
    
    let valueElapsed: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var timer: Timer?
    private var elapsedTime: Double = 0.0
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
    
    init(workoutManager: WorkoutServiceIos) {
        super.init(frame: .zero)
        updateLabel(workoutManager.elapsedTimeInterval)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(valueElapsed)
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
//    func startStopwatch() {
//        timer?.invalidate()
//        elapsedTime = 0.0
////        updateLabel()
//        
//        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
//        
//    }
    
//    @objc
//    private func updateCountdown() {
//        elapsedTime += 0.1
////        updateLabel()
//    }
//    
//    func stopStopwatch() {
//        timer?.invalidate()
//    }
    
    private func updateLabel(_ value: TimeInterval) {
        // Memformat waktu sebagai hh.mm.ss,SS (jam, menit, detik, ratusan detik)
        let hours = Int(value) / 3600
        let minutes = (Int(value) % 3600) / 60
        let seconds = Int(value) % 60
        let hundredths = Int((value - floor(value)) * 100) // Mendapatkan nilai ratusan detik
        
        valueElapsed.text = String(format: "%02d.%02d.%02d,%02d", hours, minutes, seconds, hundredths)
        
        print("value elapsed : \(valueElapsed.text!)")
    }
    
//    deinit {
//        timer?.invalidate()
//    }
    
}

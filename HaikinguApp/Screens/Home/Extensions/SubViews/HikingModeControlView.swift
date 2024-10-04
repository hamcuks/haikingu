//
//  HikingModeControlView.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit

class HikingModeControlView: UISegmentedControl {
    
    private lazy var radius = self.bounds.height / 2
    private var segmentInset: CGFloat = 6 {
        didSet {
            if segmentInset == 0 {
                segmentInset = 6
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        self.
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        
        let selectedMode = numberOfSegments
        
        if let mode = subviews[selectedMode] as? UIImageView {
            mode.backgroundColor = .gray
            mode.image = nil
            mode.layer.cornerRadius = self.radius - segmentInset + 4
            mode.layer.masksToBounds = true
            mode.bounds = mode.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            mode.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}

//
//  HikingModeControlView.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit

#warning("TODO: create custom control")
class HikingModeControlView: UISegmentedControl {

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
    }
}

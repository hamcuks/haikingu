//
//  UIView+Extension.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 04/10/24.
//

import UIKit

extension UIView {
    func takeScreenshot(of rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { ctx in
            self.drawHierarchy(in: CGRect(origin: CGPoint(x: -rect.origin.x, y: -rect.origin.y), size: self.bounds.size), afterScreenUpdates: true)
        }
    }
}

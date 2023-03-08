//
//  UIView+Extensions.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit

extension UIView {
    
    
    // MARK: - 設定圓角
    func setCornerRadiusCircle() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    
}


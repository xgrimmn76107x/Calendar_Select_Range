//
//  CusomUIButton.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation
import UIKit

@IBDesignable
class PressEffectBtn: UIButton {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.3
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = .cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = cornerRadius
    }
}


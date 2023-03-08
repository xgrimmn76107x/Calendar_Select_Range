//
//  ThumbTextSlider.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit
import SwiftDate


class ThumbTextSlider: UISlider {
    var thumbTextLabel: UILabel = UILabel()
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        return thumb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbTextLabel.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.origin.y, width: thumbFrame.size.width, height: thumbFrame.size.height)
        self.setValue()
    }
    
    private func setValue() {
//        thumbTextLabel.text = Defaults[\.customerSelectDate].startDate.toFormat("h:mm a", locale: Locale(identifier: Locales.chineseTaiwan.rawValue))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.textColor = .white
        thumbTextLabel.adjustsFontSizeToFitWidth = true
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
        
        let thumb = thumbImage()
        setThumbImage(thumb, for: .normal)
    }
    
    private func thumbImage() -> UIImage {
        let width = 80
        thumbView.frame = CGRect(x: 0, y: 15, width: width, height: 40)
        thumbView.layer.cornerRadius = 20
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
//            rendererContext.cgContext.setShadow(offset: .zero, blur: 5, color: UIColor.customBlue.cgColor)
            thumbView.backgroundColor = .customBlue
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 5))
    }
}


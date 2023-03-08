//
//  DateCalendarCell.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
    case leftBorder_circle
    case rightBorder_circle
    case twoInOne
}

class DateCalendarCell: FSCalendarCell {

//    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!

    fileprivate var lightBlue: UIColor = .customBlue008
    fileprivate var darkBlue: UIColor = .customBlue

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

//        let circleImageView = UIImageView(image: .star)
//        self.contentView.insertSubview(circleImageView, at: 0)
//        self.circleImageView = circleImageView

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = darkBlue.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, at: 0)
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true
//        self.titleLabel.textColor = .systemYellow
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        self.backgroundView = view

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.contentView.bounds.height
        let distance = (self.contentView.bounds.width - width) / 2
        let frame = CGRect(x: self.contentView.bounds.minX + distance, y: self.contentView.bounds.minY, width: width, height: width)

//        self.circleImageView.frame = frame
        self.eventIndicator.isHidden = true
        self.backgroundView?.frame = self.bounds.insetBy(dx: 0, dy: 0)
        self.selectionLayer.frame = self.contentView.bounds
        self.selectionLayer.fillColor = UIColor.systemBackground.cgColor
        self.titleLabel.textColor = isPlaceholder ? .secondaryLabel : .label
        selectionLayer.sublayers?.removeAll()
        if selectionType == .middle {
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .label
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .rightBorder {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: self.selectionLayer.frame.maxY / 2))
            path.addLine(to: CGPoint(x: 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: self.selectionLayer.frame.maxY - 2))
            path.addLine(to: CGPoint(x: 10, y: self.selectionLayer.frame.maxY - 2))
            path.close()
            layer.path = path.cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .leftBorder {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX, y: self.selectionLayer.frame.maxY / 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: self.selectionLayer.frame.maxY - 2))
            path.addLine(to: CGPoint(x: 10, y: self.selectionLayer.frame.maxY - 2))
            path.close()
            layer.path = path.cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX + 10, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .single {
            self.selectionLayer.fillColor = darkBlue.cgColor
            self.titleLabel.textColor = .white
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }else if selectionType == .rightBorder_circle {
            let layer = CAShapeLayer()
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            layer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        }else if selectionType == .leftBorder_circle {
            let layer = CAShapeLayer()
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            layer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX + 10, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        }else if selectionType == .twoInOne {
            let layer = CAShapeLayer()
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            layer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2 + 4, y: self.contentView.frame.height / 2 - diameter / 2 + 4, width: diameter - 8, height: diameter - 8)).cgPath
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 1.5
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = darkBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        } else {
            self.selectionLayer.fillColor = UIColor.systemBackground.cgColor
            self.titleLabel.textColor = isPlaceholder ? .secondaryLabel : .label
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            //change from rectangle to circle as background flicks from circle to rectangle
        }

    }

    override func configureAppearance() {
        super.configureAppearance()
        self.eventIndicator.isHidden = true
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.titleLabel.textColor = .secondaryLabel
        } else {
            self.titleLabel.textColor = .label
        }
    }

}


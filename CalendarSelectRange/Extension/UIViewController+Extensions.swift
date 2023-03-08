//
//  UIViewController+Extensions.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit


extension UIViewController {
    // MARK: - Navigation Setup
    func navigationSetup(_ text: String, _ tintColor: UIColor = .label) {
        if self == self.navigationController?.viewControllers.first {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .cross_black, style: .plain, target: self, action: #selector(closeBtnPressed))
        }else {
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        }

        self.title = text
        self.navigationController?.navigationBar.tintColor = tintColor
    }

    // MARK: - Dismiss
    @objc func closeBtnPressed() {
        // MARK: 判斷是要PopViewController OR Dismiss ViewController
        Tools.popOrDismissViewController(self.navigationController, self)
    }
}


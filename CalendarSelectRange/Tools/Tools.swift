//
//  Tools.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit

class Tools {
    
    // MARK: - 觸發手機震動
    class func vibrationStart(_ impactStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // MARK: - Alert
    class func setMultiActions(_ actions: [String], handler: ((Int) -> Void)? = nil) -> [UIAlertAction] {
        var alertActions: [UIAlertAction] = []
        for (index, actionTitle) in actions.enumerated() {
            alertActions.append(UIAlertAction(title: actionTitle, style: .default) { _ in
                handler?(index)
            })
        }
        
        return alertActions
    }
    
    class func showAlertController(alertController: UIAlertController) {
//        let keyWindow: UIWindow?
//        if #available(iOS 13.0, *) {
//            keyWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first
//        } else {
//            keyWindow = UIApplication.shared.keyWindow
//        }
//        var presentedViewController = keyWindow?.rootViewController
//        while presentedViewController?.presentedViewController != nil {
//            presentedViewController = presentedViewController?.presentedViewController
//        }
//        DispatchQueue.main.async(execute: {
//            presentedViewController?.present(alertController, animated: true)
//        })
        self.presentOnTop(alertController)
    }
    
    // MARK: - 得到最後Presented ViewController
    static func getLastPresentedViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        var presentedViewController = keyWindow?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
    
    
    // MARK: - present
    class func presentOnTop(_ viewController:UIViewController, presentStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical){
        let presentedViewController = getLastPresentedViewController()
        DispatchQueue.main.async(execute: {
            viewController.modalPresentationStyle = presentStyle
            viewController.modalTransitionStyle = transitionStyle
            presentedViewController?.present(viewController, animated: true)
        })
        
    }
    
    // MARK: - present With UINavigation
    class func presentWithUINavigationOnTop(_ viewController:UIViewController, presentStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical){
        let presentedViewController = getLastPresentedViewController()
        DispatchQueue.main.async(execute: {
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = presentStyle
            nav.modalTransitionStyle = transitionStyle
            presentedViewController?.present(nav, animated: true)
        })
        
    }
    
    
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController
        {
            return currentViewController(base: presented)
        }
        return base
    }
    
    class func getNavigationController() -> UINavigationController? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        if let tabBarController = window?.rootViewController as? UITabBarController{
            if let nvc = tabBarController.selectedViewController as? UINavigationController{
                //let vc = nvc.viewControllers.first
                return nvc
            }
        }
        return nil
    }
    
    // MARK: - 判斷是要PopViewController OR Dismiss ViewController
        static func popOrDismissViewController(_ naviController: UINavigationController? = currentViewController()?.navigationController, _ viewController: UIViewController, completion: (() -> Void)? = nil) {
            if naviController?.children.count ?? 0 <= 1 {
                viewController.dismiss(animated: true, completion: completion)
            }else {
                naviController?.popViewController(animated: true)
            }
        }
}




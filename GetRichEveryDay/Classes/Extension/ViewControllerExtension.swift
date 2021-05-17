//
//  ViewControllerExtension.swift
//  Alamofire
//
//  Created by 薛忱 on 2020/7/29.
//

import UIKit

extension UIViewController {
    
    var rootVC: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }
    
    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }
    
    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }
    
    var presentedCore: Bool {
        return presentdCore(viewController: rootVC)
    }
            
    private func presentdCore(viewController: UIViewController?) -> Bool {
        
        if viewController.self is MainTabBarController {
            return true
        }
        
        if let presentedViewController = viewController?.presentedViewController {
            return presentdCore(viewController: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return presentdCore(viewController: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return presentdCore(viewController: visibleViewController)
        }
        
        return false
    }
    
    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }
        
        return viewController
    }
    
    func present(_ controller: UIViewController, _: Bool = false) {
        //        controller.hero.isEnabled = hero
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func presentDissolve(_ controller: UIViewController,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }
    
    func presentFullScreen(_ controller: UIViewController,
                           animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }
    
    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    func presentVC(presentVC: UIViewController) {
        presentVC.modalPresentationStyle = .fullScreen
        self.present(presentVC, animated: true) {
        }
    }
    
    func presentDissolveVC(presentVC: UIViewController) {
        presentVC.modalPresentationStyle = .fullScreen
        presentVC.modalTransitionStyle = .crossDissolve
        self.present(presentVC, animated: true) {
        }
    }
    
    func presentOverfullScreenVC(presentVC: UIViewController) {
        presentVC.modalPresentationStyle = .overFullScreen
        presentVC.modalTransitionStyle = .crossDissolve
        self.present(presentVC, animated: true) {
        }
    }
}

extension UIApplication {
    func openURL(url: URL, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func openURL(url: String?, completion: ((Bool) -> Void)? = nil) {
        if let str = url,
            let url = URL(string: str) {
            openURL(url: url, completion: completion)
        }
    }
}

extension UIView {
    var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }
}

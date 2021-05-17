//
//  MainTabBarController.swift
//  Alamofire
//
//  Created by 薛忱 on 2020/7/28.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var tabBarArrays: Array<UIViewController> = []
    let costomView = TabBarCostomView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbar 跳转
        NotificationCenter.default.addObserver(self, selector: #selector(tabbarJumpToStore(notify:)), name: .GREDJumpToStore, object: nil)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        self.delegate = self
        self.tabBarController?.tabBar.delegate = self
        
        // 修改tabbar背景颜色
        
        tabBar.insertSubview(costomView, at: 0)
        costomView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        let freeCoinsVC = FreeCoinsViewController.init()
        freeCoinsVC.tabBarItem.tag = 0
        tabBarArrays.append(freeCoinsVC)
        
        let loveVC = LoveViewController.init()
        loveVC.tabBarItem.tag = 1
        tabBarArrays.append(loveVC)
        
        let adhereVC = AdhereViewController.init()
        adhereVC.tabBarItem.tag = 2
        tabBarArrays.append(adhereVC)
        
        let storeVC = StoreViewController.init()
        storeVC.tabBarItem.tag = 3
        tabBarArrays.append(storeVC)
        
        let settingVC = SettingViewController.init()
        settingVC.tabBarItem.tag = 4
        tabBarArrays.append(settingVC)
        
        self.viewControllers = tabBarArrays
        self.tabBar.isTranslucent = false
        self.selectedIndex(index: 0)
    }
    
    func selectedIndex(index: Int) {
        self.costomView.animation(tag: index)
        self.selectedIndex = index
    }
    
    func addTabBarItem(title: String?, vc: UIViewController) {
        vc.tabBarItem.title = title
    }
    
    @objc func tabbarJumpToStore(notify: Notification) {
        self.selectedIndex(index: 3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.tintColor = UIColor.init(hexString: "#191919")
        tabBar.layer.cornerRadius = 30
        tabBar.layer.masksToBounds = true
        tabBar.frame = CGRect(x: 20,
                              y: Int(view.frame.height) - 80,
                              width: Int(view.frame.width) - 40,
                              height: 60)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        self.costomView.animation(tag: tabBarController.tabBar.selectedItem?.tag ?? 1)
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

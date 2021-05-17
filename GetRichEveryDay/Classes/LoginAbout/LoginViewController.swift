//
//  LoginViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/3.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginPageDismiss(notify:)), name: .GREDLoginPageDismiss, object: nil)

        // Do any additional setup after loading the view.
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(withBundleName: "log_in_bg_pic")
        bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        let bottomBGView = UIView()
        bottomBGView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        bottomBGView.layer.cornerRadius = 34
        bottomBGView.backgroundColor = .white
        self.view.addSubview(bottomBGView)
        bottomBGView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.left.equalTo(38)
            make.bottom.equalTo(-117)
            make.height.equalTo(68)
        }
        
        let littleImageView = UIImageView()
        littleImageView.image = UIImage(withBundleName: "instagram_fill_ic")
        bottomBGView.addSubview(littleImageView)
        littleImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerY.equalTo(bottomBGView.snp.centerY).offset(0)
            make.right.equalTo(-80)
        }
        
        let bottomTitleLabel = UILabel()
        bottomTitleLabel.text = "Sign in with Instagram"
        bottomTitleLabel.textAlignment = .right
        bottomTitleLabel.textColor = UIColor.init(hexString: "#000000")
        bottomTitleLabel.font = UIFont(name: fontHiraginoSansW6, size: 16)
        bottomBGView.addSubview(bottomTitleLabel)
        bottomTitleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(littleImageView.snp.left).offset(-12)
        }
        
        let bottomLabel = UILabel()
        bottomLabel.text = "APP Does Not Store User Information"
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont(name: fontHiraginoSansW3, size: 12)
        self.view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(bottomBGView.snp.bottom).offset(21)
            make.height.equalTo(14)
        }
        
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomBGView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    @objc func buttonClick(button: UIButton) {
        LogInManage.showNativeView(controller: UIViewController.currentViewController() ?? self)
//        self.dismiss(animated: true) {
//        }
    }
    
    @objc func loginPageDismiss(notify: Notification) {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogInManage.default.showedLoginVC = true
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

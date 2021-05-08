//
//  PGISettingVC.swift
//  PGIymPicGridIn
//
//  Created by JOJO on 2021/4/28.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit



let AppName: String = "Insta Gird"
let purchaseUrl = ""
let TermsofuseURLStr = "http://certain-direction.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://adorable-muscle.surge.sh/Privacy_Agreement.html"

let feedbackEmail: String = "xjabsuauxnd@yandex.com"
let AppAppStoreID: String = ""



class PGISettingVC: UIViewController {

    let closeBtn = UIButton(type: .custom)
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    let loginBtnLine = UIView()
    let logoutBtn = UIButton(type: .custom)
    let logoutBtnLine = UIView()
    let userNameLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        updateUserAccountStatus()
        
    }
    
    func setupView() {
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "store_icon_return"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        let titleLabel = UILabel(text: "Setting")
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        titleLabel.textColor = UIColor(hexString: "#FFDC46")
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
        let left: CGFloat = (UIScreen.main.bounds.width - (115 * 2) - 1) / 3
        
        let feedBgV = UIView()
        feedBgV.backgroundColor = UIColor(hexString: "#FFDC46")
        feedBgV.layer.cornerRadius = 6
        view.addSubview(feedBgV)
        feedbackBtn.setTitleColor(UIColor.white, for: .normal)
        feedbackBtn.backgroundColor = .white
        feedbackBtn.layer.cornerRadius = 6
        feedbackBtn.titleLabel?.font = UIFont(name: "IBMPlexSans-SemiBold", size: 24)
        feedbackBtn.setTitle("Feedback", for: .normal)
        view.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(115)
            $0.height.equalTo(85)
            $0.left.equalTo(left)
            $0.top.equalTo(backBtn.snp.bottom).offset(160)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        //
        let feedIconImgV = UIImageView(image: UIImage(named: "settings_icon_feedback"))
        feedIconImgV.contentMode = .center
        view.addSubview(feedIconImgV)
        feedIconImgV.snp.makeConstraints {
            $0.centerX.equalTo(feedbackBtn)
            $0.centerY.equalTo(feedbackBtn).offset(-12)
            $0.width.height.equalTo(44)
        }
        let feedLabel = UILabel()
        feedLabel.textColor = .black
        feedLabel.text = "Feedback"
        feedLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        view.addSubview(feedLabel)
        feedLabel.snp.makeConstraints {
            $0.centerX.equalTo(feedbackBtn)
            $0.centerY.equalTo(feedbackBtn).offset(12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        //
        feedBgV.snp.makeConstraints {
            $0.centerX.equalTo(feedbackBtn).offset(3)
            $0.centerY.equalTo(feedbackBtn).offset(4)
            $0.width.height.equalTo(feedbackBtn)
        }
        
        //
        let termsBgV = UIView()
        termsBgV.backgroundColor = UIColor(hexString: "#FFDC46")
        termsBgV.layer.cornerRadius = 6
        view.addSubview(termsBgV)
        termsBtn.backgroundColor = .white
        termsBtn.layer.cornerRadius = 6
        termsBtn.setTitleColor(UIColor.white, for: .normal)
        termsBtn.titleLabel?.font = UIFont(name: "IBMPlexSans-SemiBold", size: 24)
        termsBtn.setTitle("Terms of use", for: .normal)
        view.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(115)
            $0.height.equalTo(85)
            $0.right.equalTo(-left)
            $0.top.equalTo(feedbackBtn)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
//        let priIconImgV = UIImageView(image: UIImage(named: "settings_icon_privacy"))
        let termIconImgV = UIImageView(image: UIImage(named: "settings_icon_term"))
        termIconImgV.contentMode = .center
        view.addSubview(termIconImgV)
        termIconImgV.snp.makeConstraints {
            $0.centerX.equalTo(termsBtn)
            $0.centerY.equalTo(termsBtn).offset(-12)
            $0.width.height.equalTo(44)
        }
        let termLabel = UILabel()
        termLabel.textColor = .black
        termLabel.text = "Term of use"
        termLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        view.addSubview(termLabel)
        termLabel.snp.makeConstraints {
            $0.centerX.equalTo(termsBtn)
            $0.centerY.equalTo(termsBtn).offset(12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        termsBgV.snp.makeConstraints {
            $0.centerX.equalTo(termsBtn).offset(3)
            $0.centerY.equalTo(termsBtn).offset(4)
            $0.width.height.equalTo(termsBtn)
        }
        
        //
        //
        let privacyBgV = UIView()
        privacyBgV.backgroundColor = UIColor(hexString: "#FFDC46")
        privacyBgV.layer.cornerRadius = 6
        view.addSubview(privacyBgV)
        privacyBtn.layer.cornerRadius = 6
        privacyBtn.backgroundColor = .white
        privacyBtn.setTitleColor(UIColor.white, for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "IBMPlexSans-SemiBold", size: 24)
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        view.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(115)
            $0.height.equalTo(85)
            $0.left.equalTo(feedbackBtn)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(36)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        
        privacyBgV.snp.makeConstraints {
            $0.centerX.equalTo(privacyBtn).offset(3)
            $0.centerY.equalTo(privacyBtn).offset(4)
            $0.width.height.equalTo(privacyBtn)
        }
        let priIconImgV = UIImageView(image: UIImage(named: "settings_icon_privacy"))
        priIconImgV.contentMode = .center
        view.addSubview(priIconImgV)
        priIconImgV.snp.makeConstraints {
            $0.centerX.equalTo(privacyBtn)
            $0.centerY.equalTo(privacyBtn).offset(-12)
            $0.width.height.equalTo(44)
        }
        let priLabel = UILabel()
        priLabel.textColor = .black
        priLabel.text = "Privacy Policy"
        priLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        view.addSubview(priLabel)
        priLabel.snp.makeConstraints {
            $0.centerX.equalTo(privacyBtn)
            $0.centerY.equalTo(privacyBtn).offset(12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        // login
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        loginBtn.setTitle("Log in", for: .normal)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(feedbackBtn.snp.top).offset(-34)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        //
        view.addSubview(loginBtnLine)
        loginBtnLine.backgroundColor = .white
        loginBtnLine.layer.cornerRadius = 1
        loginBtnLine.snp.makeConstraints {
            $0.bottom.equalTo(loginBtn)
            $0.centerX.equalTo(loginBtn)
            $0.height.equalTo(2)
            $0.width.equalTo(78)
        }
        
        // logout
        logoutBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        logoutBtn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        logoutBtn.setTitle("Log out", for: .normal)
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(40)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
        //
        view.addSubview(logoutBtnLine)
        logoutBtnLine.backgroundColor = .white
        logoutBtnLine.layer.cornerRadius = 1
        logoutBtnLine.snp.makeConstraints {
            $0.bottom.equalTo(logoutBtn)
            $0.centerX.equalTo(logoutBtn)
            $0.height.equalTo(2)
            $0.width.equalTo(78)
        }
        
        // user name label
        view.addSubview(userNameLabel)
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(35)
            $0.centerY.equalTo(loginBtn)
        }
        
        
    }
     

}



extension PGISettingVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}

extension PGISettingVC {
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    @objc func logoutBtnClick(sender: UIButton) {
        LoginManage.shared.logout()
        updateUserAccountStatus()
    }
    
    func showLoginVC() {
        if LoginManage.currentLoginUser() == nil {
            let loginVC = LoginManage.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginManage.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Tourist"
            userNameLabel.isHidden = false
            logoutBtn.isHidden = false
            logoutBtnLine.isHidden = false
            loginBtn.isHidden = true
            loginBtnLine.isHidden = true
        } else {
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            logoutBtn.isHidden = true
            logoutBtnLine.isHidden = true
            loginBtn.isHidden = false
            loginBtnLine.isHidden = false
        }
    }
}



extension PGISettingVC: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}


extension UIDevice {
  
   ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
   var modelName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
      
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8, value != 0 else {
               return identifier
           }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
      
       switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
           case "iPhone4,1":                               return "iPhone 4s"
           case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
           case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
           case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
           case "iPhone7,2":                               return "iPhone 6"
           case "iPhone7,1":                               return "iPhone 6 Plus"
           case "iPhone8,1":                               return "iPhone 6s"
           case "iPhone8,2":                               return "iPhone 6s Plus"
           case "iPhone8,4":                               return "iPhone SE"
           case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
           case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
           case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6":                return "iPhone X"
           case "iPhone11,2":                              return "iPhone XS"
           case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
           case "iPhone11,8":                              return "iPhone XR"
           case "iPhone12,1":                              return "iPhone 11"
           case "iPhone12,3":                              return "iPhone 11 Pro"
           case "iPhone12,5":                              return "iPhone 11 Pro Max"
           case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
           case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
           case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
           case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
           case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
           case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
           case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
           case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
           case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
           case "AppleTV5,3":                              return "Apple TV"
           case "i386", "x86_64":                          return "Simulator"
           default:                                        return identifier
       }
   }
}



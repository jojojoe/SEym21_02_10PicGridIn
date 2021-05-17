//
//  ViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/2.
//

import UIKit
import DeviceKit
import MessageUI
import Alertift

class SettingViewController: UIViewController {
    
    var arrayUserData: Array<UserModel> = []
    let topView = TopUserCoinsView()
    let tableView = UITableView()
    let cellID = "UserListViewController"
    let feedBackButton = UIButton()
    let logoutButton = UIButton()
    let addAccountbutton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        topView.backgroundColor = .black
        topView.loadCurrentUserInfo()
        topView.enterStyle(styel: .coins)
        topView.coinsButtonClickCallBack = {
            NotificationCenter.default.post(name: .GREDJumpToStore, object: nil)
        }
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(currentDiviceIsFullSceen() ? 88 : 64)
        }
        
        tableView.backgroundColor = UIColor.hexColor(hex: "#000000")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(119)
            make.left.right.equalTo(0)
            make.height.equalTo(arrayUserData.count * 56)
        }
        
        feedBackButton.setTitle("Feedback", for: .normal)
        feedBackButton.titleLabel?.font = UIFont(name: fontHiraginoSansW6, size: 14)
        feedBackButton.addTarget(self, action: #selector(feedbackButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(feedBackButton)
        feedBackButton.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        

        self.logoutButton.setTitleColor(UIColor.init(hexString: "#515151"), for: .normal)
        let str = NSMutableAttributedString(string: "Log out")
        let strRange = NSRange.init(location: 0, length: str.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#515151"),
                           NSAttributedString.Key.font: UIFont(name: fontHiraginoSansW6, size: 14)], range: strRange)
        logoutButton.setAttributedTitle(str, for: UIControl.State.normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(feedBackButton.snp.bottom).offset(14)
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
        }
        
        addAccountbutton.backgroundColor = UIColor.init(hexString: "#191919")
        addAccountbutton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        addAccountbutton.layer.cornerRadius = 19
        addAccountbutton.layer.masksToBounds = true
        addAccountbutton.setTitle("Add account", for: .normal)
        addAccountbutton.setTitleColor(UIColor.init(hexString: "#E7157F"), for: .normal)
        addAccountbutton.titleLabel?.font = UIFont(name: fontHiraginoSansW6, size: 14)
        addAccountbutton.sizeToFit()
        addAccountbutton.addTarget(self, action: #selector(addAccountbuttonClick(button:)), for: .touchUpInside)
        self.view.addSubview(addAccountbutton)
        addAccountbutton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-64)
            make.width.equalTo(132)
            make.height.equalTo(38)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
    
    @objc func logoutButtonClick(button: UIButton) {
        Alertift.alert(title: "Are you sure to log out?", message: nil)
                .action(.cancel("Cancel"))
                .action(.default("Yes, I'm")) { _, _, _ in
                    UserManage.default.logoutUser()
                }
                .show(on: visibleVC, completion: nil)
    }
    
    @objc func addAccountbuttonClick(button: UIButton) {
        
        if self.arrayUserData.count >= 3 {
            Alertift.alert(title: "Max up to 3 users", message: nil)
                    .action(.default("Yes")) { _, _, _ in
                    }
                    .show(on: visibleVC, completion: nil)
            return
        }
        
        LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
    }
    
    @objc func feedbackButtonClick(button: UIButton) {
        guard let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            let buildNumber = UIApplication.shared.version,
            let version = Device.current.systemVersion,
            let model = Device.current.model else { return }
        let address = UserManage.default.currentUserModel?.feedbackEmail ?? "feedbackwithsophia@gmail.com"
        let identifier = Device.identifier
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()

            let title = "\(appName)_Feedback"
            let body = "<br /><br /><br /><br /><font color=\"#9F9F9F\" style=\"font-size: 13px;\"> <i>(\(appName) \(buildNumber) on \(model) running with iOS \(version), device \(identifier)</i>)</font>"

            mailVC.setSubject(title)
            mailVC.setToRecipients([address])
            mailVC.setMessageBody(body, isHTML: true)
            mailVC.mailComposeDelegate = self
            visibleVC?.presentFullScreen(mailVC)
        } else {
            UIApplication.shared.openURL(url: "mailto:\(address)")
        }
    }
    
    @objc func userlogin(notify: Notification) {
        loadData()
    }
    
    func loadData() {
        MarsCache.obtainUserList()
        self.arrayUserData = UserManage.default.userModels
        self.tableView.reloadData()
        self.tableView.snp.updateConstraints { (make) in
            make.height.equalTo(arrayUserData.count * 56)
        }
        self.tableView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        topView.loadCurrentUserInfo()
        
        //如果没有 user 则弹出登录页
        if self.arrayUserData.count == 0 {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
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

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.arrayUserData.count
        
        if count == 0 {
            self.logoutButton.isHidden = true
            addAccountbutton.setTitle("Log in", for: .normal)
        } else if count > 0 {
            self.logoutButton.isHidden = false
            addAccountbutton.setTitle("Add account", for: .normal)
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: cellID)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserListTableViewCell
        if cell == nil {
            cell =  UserListTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.contentView.backgroundColor = .black
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let myCell = cell as? UserListTableViewCell
        
        myCell?.userIcon.backgroundColor = .systemPink
        let item = arrayUserData[safe: indexPath.row]
        myCell?.enterUserName(userName: item?.userName ?? "")
        myCell?.userIcon.kf.indicatorType = .activity
        myCell?.userIcon.kf.setImage(with: URL.init(string: item?.userIconUrl))
        myCell?.selectImageView.isHidden = indexPath.row == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24 + 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > 0 {
            let item = arrayUserData[safe: indexPath.row]
            let manage = UserManage.default
            manage.currentUserModel = item
            UserManage.requestNativeUserInfoAndNodes(userName: item?.userName ?? "", showAd: true, showHub: true)
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

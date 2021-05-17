//
//  TopUserCoinsView.swift
//  Adjust
//
//  Created by 薛忱 on 2020/12/4.
//

import UIKit

enum TopUserCoinsViewStyle {
    case nameAndCoins
    case coins
    case backAndCoins
}

class TopUserCoinsView: UIView {
    
    let userNameLabel = UILabel()
    let coinsButton = UIButton()
    let coinsLabel = UILabel()
    let backButton = UIButton()
    var coinsButtonClickCallBack: ButtonClickBlock?
    var backButtonClickCallBack: ButtonClickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        userNameLabel.textAlignment = .left
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont(name: fontHiraginoSansW6, size: 14)
        self.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.height.equalTo(16)
            make.bottom.equalTo(-10)
        }
        
        coinsLabel.textColor = .white
        coinsLabel.textAlignment = .right
        coinsLabel.font = UIFont(name: fontHiraginoSansW6, size: 14)
        self.addSubview(coinsLabel)
        coinsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-24)
            make.height.equalTo(16)
            make.centerY.equalTo(userNameLabel.snp.centerY)
        }

        coinsButton.addTarget(self, action: #selector(coinsButtonClick(button:)), for: .touchUpInside)
        self.addSubview(coinsButton)
        coinsButton.snp.makeConstraints { (make) in
            make.right.equalTo(coinsLabel.snp.right).offset(5)
            make.left.equalTo(coinsLabel.snp.left).offset(-5)
            make.height.equalTo(40)
            make.centerY.equalTo(coinsLabel.snp.centerY).offset(0)
        }
        
        backButton.setImage(UIImage(withBundleName: "buy_back_ic"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick(button:)), for: .touchUpInside)
        self.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(coinsLabel.snp.centerY)
            make.left.equalTo(9)
        }
    }
    
    @objc func coinsButtonClick(button: UIButton) {
        coinsButtonClickCallBack?()
    }
    
    @objc func backButtonClick(button: UIButton) {
        backButtonClickCallBack?()
    }
    
//    func enterUserName(userName: String) {
//        self.userNameLabel.text = "@" + userName
//    }
//
//    func enterCoinsNum(coinsNum: String) {
//        self.coinsLabel.text = "🌟" + coinsNum
//    }
    
    func enterStyle(styel: TopUserCoinsViewStyle) {
        switch styel {
        case .nameAndCoins:
            self.userNameLabel.isHidden = false
            self.backButton.isHidden = true
            break
            
        case .coins:
            self.userNameLabel.isHidden = true
            self.backButton.isHidden = true
            break
            
        case .backAndCoins:
            self.userNameLabel.isHidden = true
            self.backButton.isHidden = false
            break
        }
    }
    
    func loadCurrentUserInfo() {
        guard let currentUserModel = UserManage.default.currentUserModel else {
            self.coinsLabel.text = "🌟" + "0"
            self.userNameLabel.text = ""
            return
        }
        
        self.coinsLabel.text = "🌟" + (currentUserModel.userNativeCoinsNum?.string ?? "0")
        self.userNameLabel.text = "@" + (currentUserModel.userName ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

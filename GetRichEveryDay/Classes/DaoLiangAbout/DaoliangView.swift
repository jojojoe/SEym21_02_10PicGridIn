//
//  DaoliangView.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/9.
//

import UIKit
import AdSupport

class DaoliangView: UIView {
    
    let daoliangTitle = UILabel()
    let daoliangAppIcon = UIImageView()
    let daoliangAppName = UILabel()
    let daoliangDesc = UILabel()
    let downloadButton = UIButton()
    var schemeModel: DaoliangSchemeModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gradientColors = [UIColor.init(hexString: "#3456FD")?.cgColor, UIColor.init(hexString: "#B00AD2")?.cgColor, UIColor.init(hexString: "#ED1674")?.cgColor]
        let gradientLocations:[NSNumber] = [0.0, 1.0]
                 
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors as [Any]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                 
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth_Int, height: 66)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        let getFreeLabel = UILabel()
        getFreeLabel.backgroundColor = .white
        getFreeLabel.text = "Get Free!"
        getFreeLabel.font = UIFont(name: fontHiraginoSansW6, size: 12)
        getFreeLabel.textAlignment = .center
        getFreeLabel.textColor = UIColor.init(hexString: "#E21485")
        getFreeLabel.layer.cornerRadius = 15
        getFreeLabel.layer.masksToBounds = true
        self.addSubview(getFreeLabel)
        getFreeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.right.equalTo(-24)
            make.centerY.equalTo(self)
        }
        
        self.daoliangAppIcon.backgroundColor = .clear
        self.addSubview(self.daoliangAppIcon)
        self.daoliangAppIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(38)
            make.left.equalTo(24)
            make.centerY.equalTo(self)
        }
        
        self.daoliangAppName.textColor = UIColor.init(hexString: "#FFFFFF", transparency: 0.46)
        self.daoliangAppName.textAlignment = .left
        self.daoliangAppName.font = UIFont(name: fontHiraginoSansW3, size: 15)
        self.addSubview(self.daoliangAppName)
        self.daoliangAppName.snp.makeConstraints { (make) in
            make.height.equalTo(11)
            make.left.equalTo(72)
            make.bottom.equalTo(-17)
            make.right.equalTo(-114)
        }
                    
        self.daoliangDesc.textColor = UIColor.hexColor(hex: "#FFFFFF", alpha: 1)
        self.daoliangDesc.font = UIFont(name: fontHiraginoSansW6, size: 13)
        self.daoliangDesc.textAlignment = .left
        self.addSubview(daoliangDesc)
        daoliangDesc.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.left.equalTo(72)
            make.top.equalTo(17)
            make.right.equalTo(-114)
        }
        
        self.downloadButton.backgroundColor = UIColor.clear
        self.downloadButton.setTitleColor(.white, for: .normal)
        self.downloadButton.titleLabel?.font = UIFont(name: fontAvenirBlack, size: 18)
        self.downloadButton.titleLabel?.textAlignment = .center
        self.downloadButton.addTarget(self, action: #selector(downloadbuttonClick(button:)), for: .touchUpInside)
        self.downloadButton.layer.cornerRadius = 23
        self.downloadButton.layer.masksToBounds = true
        self.addSubview(self.downloadButton)
        self.downloadButton.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    func assignmentDaoliang(model: DaoliangSchemeModel) {
        self.schemeModel = model
        self.daoliangAppIcon.kf.indicatorType = .activity
        self.daoliangAppIcon.kf.setImage(with: URL.init(string: model.failpyIcon))
        self.daoliangAppName.text = model.productName
        let config = NativeConfigManage.default.config
        self.daoliangTitle.text = config?.cfgDliangTitle ?? ""
        self.daoliangDesc.text = config?.cfgDliangDesc ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func downloadbuttonClick(button: UIButton) {

        let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if let appURL = URL.init(string: (schemeModel?.failpyUrl ?? "") + "?idfa=" + uuid) {
            UIApplication.shared.openURL(url: appURL)
            RequestNetWork.requestReardPost(productScheme: schemeModel?.scheme ?? "", deviceID: uuid) {
                debugPrint("success")
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

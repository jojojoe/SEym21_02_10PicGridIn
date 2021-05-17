//
//  PostView.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/9.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

protocol PostViewDelegate: class {
    func skipButtonClick()
    func tipButtonClick()
}

class PostView: UIView {

    let mainImageView = UIImageView()
//    let skipButton = UIButton()
    var tipButton = UIButton()
    var lastBetrayTime: TimeInterval = Date().unixTimestamp
    let emptyImageView = UIImageView()
    
    weak var delegate: PostViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        emptyImageView.backgroundColor = UIColor.hexColor(hex: "#FFFFFF")
        emptyImageView.image = UIImage(withBundleName: "tupianjiazaishibai")
        emptyImageView.contentMode = .center
        self.addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints { (make) in
            make.width.equalTo(93)
            make.height.equalTo(77)
            make.center.equalTo(self)
        }
        
        self.mainImageView.backgroundColor = UIColor.hexColor(hex: "#F5F6FA")
        self.mainImageView.layer.masksToBounds = true
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.isHidden = true
        self.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        tipButton.setImage(UIImage(withBundleName: "he_ic_tips"), for: .normal)
        tipButton.addTarget(self, action: #selector(tipButtonClick(button:)), for: .touchUpInside)
        self.addSubview(tipButton)
        tipButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.right.equalTo(0)
        }
    }
    
    func changePlaceholder(isEmpty: Bool) {
        if isEmpty {
            emptyImageView.image = UIImage(withBundleName: "empty")
        } else {
            emptyImageView.image = UIImage(withBundleName: "tupianjiazaishibai")
        }
    }
    
    func showAdhere(model: AdherePostModel?) {
        
        let url = model?.profileUrl
         
        if  (url?.count ?? 0) > 0 {
            self.mainImageView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(198)
                make.center.equalTo(self)
            }
            self.layoutIfNeeded()
            
            self.mainImageView.layer.cornerRadius = 99
                        
            self.mainImageView.setKfImage(imagePath: url!)
            self.mainImageView.isHidden = false
        } else {
            self.mainImageView.isHidden = true
        }
        
    }
    
    func showLove(model: LovePostModel?) {
        let url = model?.media_thumbnail_url
        if (url?.count ?? 0) > 0 {
            self.mainImageView.snp.remakeConstraints { (make) in
                make.top.left.bottom.right.equalTo(0)
            }
            self.layoutIfNeeded()
            
            self.mainImageView.layer.cornerRadius = 0
            self.mainImageView.setKfImage(imagePath: url!)
            self.mainImageView.isHidden = false
        } else {
            
            self.mainImageView.isHidden = true
//            blurView?.backgroundColor = UIColor.hexColor(hex: "#202020", alpha: 0.2)
        }
    }
    
    @objc func skipButtonClick(button: UIButton) {
        button.backgroundColor = UIColor.hexColor(hex: "#202020", alpha: 0.2)
        let gapConfig: Double = NativeConfigManage.default.config?.cfgSendOrderIntervalTime?.double ?? 0.5
        let offset = Date().unixTimestamp - lastBetrayTime

        if offset > gapConfig {
            self.delegate?.skipButtonClick()
            lastBetrayTime = Date().unixTimestamp
        } else {
            lastBetrayTime += gapConfig
            let afterTime = abs(Date().unixTimestamp - lastBetrayTime)
            Timer.after(afterTime) {
                self.delegate?.skipButtonClick()
            }
        }
    }
    
    @objc func skipButtonClickHeightLight(button: UIButton) {
        button.backgroundColor = UIColor.hexColor(hex: "#202020", alpha: 0.8)
    }
    
    @objc func tipButtonClick(button: UIButton) {
        self.delegate?.tipButtonClick()
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

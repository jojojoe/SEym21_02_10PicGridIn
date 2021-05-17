//
//  TabBarCostomView.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/4.
//

import UIKit

class TabBarCostomView: UIView {
    
    let freeCoinsButton = UIButton()
    let loveButton = UIButton()
    let adhereButton = UIButton()
    let storeButton = UIButton()
    let settingButton = UIButton()
    let animationView = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "#191919")
        var arrayButtons: Array<UIButton> = []
        
        self.freeCoinsButton.setTitle("🌟", for: .normal)
        self.freeCoinsButton.backgroundColor = UIColor.init(hexString: "#191919")
        self.freeCoinsButton.tag = 1000
        self.freeCoinsButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(freeCoinsButton)
        arrayButtons.append(freeCoinsButton)
        
        self.loveButton.setTitle("💖", for: .normal)
        self.loveButton.backgroundColor = UIColor.init(hexString: "#191919")
        self.loveButton.tag = 1001
        self.loveButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(loveButton)
        arrayButtons.append(loveButton)
        
        self.adhereButton.setTitle("👩", for: .normal)
        self.adhereButton.backgroundColor = UIColor.init(hexString: "#191919")
        self.adhereButton.tag = 1002
        self.adhereButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(adhereButton)
        arrayButtons.append(adhereButton)
        
        self.storeButton.setTitle("💰", for: .normal)
        self.storeButton.backgroundColor = UIColor.init(hexString: "#191919")
        self.storeButton.tag = 1003
        self.storeButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(storeButton)
        arrayButtons.append(storeButton)
        
        self.settingButton.setTitle("⚙️", for: .normal)
        self.settingButton.backgroundColor = UIColor.init(hexString: "#191919")
        self.settingButton.tag = 1004
        self.settingButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(settingButton)
        arrayButtons.append(settingButton)
        
        arrayButtons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 44, leadSpacing: 30, tailSpacing: 30)
        arrayButtons.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.centerY.equalTo(self)
        }
        
        animationView.backgroundColor = UIColor.init(hexString: "#FFFA3A")
        self.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(38)
            make.height.equalTo(6)
            make.bottom.equalTo(0)
            make.centerX.equalTo(self.freeCoinsButton.snp.centerX)
        }
    }
    
    func animation(tag: Int) {
        
        var button = self.freeCoinsButton
        
        switch tag {
        case 0:
            button = self.freeCoinsButton
            break
            
        case 1:
            button = self.loveButton
            break
            
        case 2:
            button = self.adhereButton
            break
            
        case 3:
            button = self.storeButton
            break
            
        case 4:
            button = self.settingButton
            break
            
        default:
            break
        }
        
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.animationView.snp.remakeConstraints { (make) in
                make.width.equalTo(38)
                make.height.equalTo(6)
                make.bottom.equalTo(0)
                make.centerX.equalTo(button.snp.centerX)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func buttonClick(button: UIButton) {
        print(button.tag)
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

//
//  MGGridBar.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit

class MGGridBar: UIView {

    let colorBtn = UIButton(type: .custom)
    let gridsBtn = UIButton(type: .custom)
    let lucencyBtn = UIButton(type: .custom)
    
    let colorView = SWBgColorView()
    let gridView = MGGrideSelectView()
    let slider: UISlider = UISlider()
    
    var alphaChangeBlock: ((CGFloat)->Void)?
    var colorChangeBlock: ((String)->Void)?
    var selectGridList: ((GridItem)->Void)?
    
    let sliderBgView = UIView()
    let colorBgView = UIView()
    let gridsBgView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupTopBtns()
        setupView()
        gridsBtnClick(sender: gridsBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension MGGridBar {
    @objc func colorBtnClick(sender: UIButton) {
        colorBtn.isSelected = true
        gridsBtn.isSelected = false
        lucencyBtn.isSelected = false
        colorBgView.isHidden = false
        gridsBgView.isHidden = true
        sliderBgView.isHidden = true
    }
    @objc func gridsBtnClick(sender: UIButton) {
        gridsBtn.isSelected = true
        colorBtn.isSelected = false
        lucencyBtn.isSelected = false
        gridsBgView.isHidden = false
        colorBgView.isHidden = true
        sliderBgView.isHidden = true
    }
    @objc func lucencyBtnClick(sender: UIButton) {
        lucencyBtn.isSelected = true
        gridsBtn.isSelected = false
        colorBtn.isSelected = false
        sliderBgView.isHidden = false
        colorBgView.isHidden = true
        gridsBgView.isHidden = true
    }
    
    
}

extension MGGridBar {
    
    func setupTopBtns() {
        colorBtn.setTitle("Color", for: .normal)
        colorBtn.setTitleColor(.black, for: .normal)
        colorBtn.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: 87, height: 24)), for: .normal)
        colorBtn.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#FFDC46") ?? .white, size: CGSize(width: 87, height: 24)), for: .selected)
        colorBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        colorBtn.layer.cornerRadius = 6
        colorBtn.layer.masksToBounds = true
        addSubview(colorBtn)
        colorBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(10)
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
        colorBtn.addTarget(self, action: #selector(colorBtnClick(sender:)), for: .touchUpInside)
        //
        gridsBtn.layer.cornerRadius = 6
        gridsBtn.layer.masksToBounds = true
        gridsBtn.setTitle("Grids", for: .normal)
        gridsBtn.setTitleColor(.black, for: .normal)
        gridsBtn.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: 87, height: 24)), for: .normal)
        gridsBtn.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#FFDC46") ?? .white, size: CGSize(width: 87, height: 24)), for: .selected)
        gridsBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        addSubview(gridsBtn)
        gridsBtn.snp.makeConstraints {
            $0.right.equalTo(colorBtn.snp.left).offset(-12)
            $0.top.equalTo(10)
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
        gridsBtn.addTarget(self, action: #selector(gridsBtnClick(sender:)), for: .touchUpInside)
        //
        lucencyBtn.layer.cornerRadius = 6
        lucencyBtn.layer.masksToBounds = true
        lucencyBtn.setTitle("Transparency", for: .normal)
        lucencyBtn.setTitleColor(.black, for: .normal)
        lucencyBtn.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: 87, height: 24)), for: .normal)
        lucencyBtn.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#FFDC46") ?? .white, size: CGSize(width: 87, height: 24)), for: .selected)
        lucencyBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        addSubview(lucencyBtn)
        lucencyBtn.snp.makeConstraints {
            $0.left.equalTo(colorBtn.snp.right).offset(12)
            $0.top.equalTo(10)
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
        lucencyBtn.addTarget(self, action: #selector(lucencyBtnClick(sender:)), for: .touchUpInside)
    }
    
    func setupView() {
        //
        
        addSubview(sliderBgView)
        sliderBgView.backgroundColor = UIColor.black
        sliderBgView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
            $0.left.right.equalToSuperview()
        }
        addSubview(colorBgView)
        colorBgView.backgroundColor = UIColor.black
        colorBgView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
            $0.left.right.equalToSuperview()
        }
        addSubview(gridsBgView)
        gridsBgView.backgroundColor = UIColor.black
        gridsBgView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
            $0.left.right.equalToSuperview()
        }
        
        
        
        slider.setMinimumTrackImage(UIImage(named: "grid_icon_color"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "grid_icon_white"), for: .normal)
        
//        slider.minimumTrackTintColor = UIColor.black
//        slider.maximumTrackTintColor = UIColor.lightGray
        slider.setThumbImage(UIImage(named: "grid_icon_1"), for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.7
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        sliderBgView.addSubview(slider)
        slider.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(67)
            $0.right.equalToSuperview().offset(-67)
            $0.height.equalTo(34)
        }
        
//        let minLabel = UILabel(text: "0")
//        minLabel.adjustsFontSizeToFitWidth = true
//        minLabel.font = UIFont(name: "IBMPlexSans-SemiBold", size: 12)
//        minLabel.textColor = UIColor(hexString: "#373737")
//        addSubview(minLabel)
//        minLabel.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(30)
//            $0.height.equalTo(20)
//            $0.width.equalTo(12)
//            $0.centerY.equalTo(slider.snp.centerY)
//        }
//
//        let maxLabel = UILabel(text: "100%")
//        maxLabel.adjustsFontSizeToFitWidth = true
//        maxLabel.font = UIFont(name: "IBMPlexSans-SemiBold", size: 12)
//        maxLabel.textColor = UIColor(hexString: "#373737")
//        addSubview(maxLabel)
//        maxLabel.snp.makeConstraints {
//            $0.right.equalToSuperview().offset(-30)
//            $0.height.equalTo(20)
//            $0.width.equalTo(35)
//            $0.centerY.equalTo(slider.snp.centerY)
//        }

        // color view
        colorView.didSelectColorBlock = {
             item in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.colorChangeBlock?(item)
                
            }
        }
//        colorView
        colorBgView.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(30)
        }
        
//        gridView
        gridView.didSelectGridBlock = {
            item in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.selectGridList?(item)
                
            }
        }
        gridsBgView.addSubview(gridView)
        gridView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
    }
    
    
    @objc func sliderValueChange(sender: UISlider) {
        debugPrint("slider change: \(sender.value)")
        let scale: CGFloat = CGFloat(sender.value)
        alphaChangeBlock?(scale)
    }
    
    
}






//
//  MGFontBar.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit

class SWTextToolView: UIView {

    let bgView = UIView()
    var collectionColor: UICollectionView!
    var collectionFont: UICollectionView!
    
    var didSelectColorBlock: ((_ color: String) -> Void)?
    var didSelectFontBlock: ((_ fontName: String) -> Void)?
    
    var currentColorHex: String?
    var currentFontName: String?
    
    let colorBtn = UIButton(type: .custom)
    let fontsBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
        setupBtns()
        setupCollectionColor()
        setupCollectionFont()
        colorBtnClick(sender: colorBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SWTextToolView {
    func replaceSetupBarStatusWith(colorHex: String, fontName: String) {
        currentColorHex = colorHex
        currentFontName = fontName
        collectionFont.reloadData()
        collectionColor.reloadData()
    }
}

extension SWTextToolView {
    
    func setupBtns() {
        
        colorBtn.setTitle("Color", for: .normal)
        colorBtn.setTitleColor(.black, for: .normal)
        colorBtn.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: 87, height: 24)), for: .normal)
        colorBtn.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#FFDC46") ?? .white, size: CGSize(width: 87, height: 24)), for: .selected)
        colorBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        colorBtn.layer.cornerRadius = 6
        colorBtn.layer.masksToBounds = true
        addSubview(colorBtn)
        colorBtn.snp.makeConstraints {
            $0.right.equalTo(snp.centerX).offset(-10)
            $0.top.equalTo(10)
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
        colorBtn.addTarget(self, action: #selector(colorBtnClick(sender:)), for: .touchUpInside)
        //
        fontsBtn.layer.cornerRadius = 6
        fontsBtn.layer.masksToBounds = true
        fontsBtn.setTitle("Font", for: .normal)
        fontsBtn.setTitleColor(.black, for: .normal)
        fontsBtn.setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: 87, height: 24)), for: .normal)
        fontsBtn.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#FFDC46") ?? .white, size: CGSize(width: 87, height: 24)), for: .selected)
        fontsBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        addSubview(fontsBtn)
        fontsBtn.snp.makeConstraints {
            $0.left.equalTo(snp.centerX).offset(10)
            $0.top.equalTo(10)
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
        fontsBtn.addTarget(self, action: #selector(fontsBtnClick(sender:)), for: .touchUpInside)
    }
    
    func setupView() {
        
        bgView.backgroundColor = .black
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().offset(0)
        }
        
        
        
    }
    
    func setupCollectionColor() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionColor = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionColor.showsVerticalScrollIndicator = false
        collectionColor.showsHorizontalScrollIndicator = false
        collectionColor.backgroundColor = .clear
        collectionColor.delegate = self
        collectionColor.dataSource = self
        bgView.addSubview(collectionColor)
        collectionColor.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
        }
        collectionColor.register(cellWithClass: SWColorCell.self)
    }
    
    
    func setupCollectionFont() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionFont = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionFont.showsVerticalScrollIndicator = false
        collectionFont.showsHorizontalScrollIndicator = false
        collectionFont.backgroundColor = .clear
        collectionFont.delegate = self
        collectionFont.dataSource = self
        bgView.addSubview(collectionFont)
        collectionFont.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY)
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        collectionFont.register(cellWithClass: SWTextCell.self)
    }
    
}

extension SWTextToolView {
    @objc func colorBtnClick(sender: UIButton) {
        colorBtn.isSelected = true
        fontsBtn.isSelected = false
        collectionColor.isHidden = false
        collectionFont.isHidden = true
    }
    @objc func fontsBtnClick(sender: UIButton) {
        colorBtn.isSelected = false
        fontsBtn.isSelected = true
        collectionFont.isHidden = false
        collectionColor.isHidden = true
    }
}
    
extension SWTextToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionColor {
            let cell = collectionView.dequeueReusableCell(withClass: SWColorCell.self, for: indexPath)
            let item = DataManager.default.textColors[indexPath.item]
            cell.colorView.backgroundColor = UIColor(hexString: item)
            
            if item.contains("000000") {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(hexString: "#FFFFFF")?.cgColor
            } else {
                cell.layer.borderWidth = 0
            }
            
            if let currentColor = self.currentColorHex, item.contains(currentColor) {
                cell.selectView.isHidden = false
            } else {
                cell.selectView.isHidden = true
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: SWTextCell.self, for: indexPath)
            
            let item = DataManager.default.textFontNames[indexPath.item]
            
            cell.textLabel.text = "Font"
            cell.textLabel.textColor = UIColor(hexString: "#FFFFFF")
            cell.textLabel.font = UIFont(name: item, size: 12)
            
            if let currentFont = self.currentFontName, item.contains(currentFont) {
                cell.textLabel.textColor = UIColor(hexString: "#FF4766")
                cell.textLabel.font = UIFont(name: currentFont, size: 14)

            } else {
                cell.textLabel.textColor = UIColor(hexString: "#FFFFFF")
                cell.textLabel.font = UIFont(name: cell.textLabel.font.fontName, size: 12)
            }
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionColor {
            return DataManager.default.textColors.count
        } else {
            return DataManager.default.textFontNames.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWTextToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionColor {
            return CGSize(width: 24, height: 24)
        } else {
            return CGSize(width: 50, height: 32)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionColor {
            return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        } else {
            return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionColor {
            return 20
        } else {
            return 8
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionColor {
            return 20
        } else {
            return 8
        }
    }
    
}

extension SWTextToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionColor {
            let color = DataManager.default.textColors[indexPath.item]
            currentColorHex = color
            didSelectColorBlock?(color)
            collectionColor.reloadData()
        } else {
            let fontName = DataManager.default.textFontNames[indexPath.item]
            currentFontName = fontName
            didSelectFontBlock?(fontName)
            collectionFont.reloadData()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

    

class SWTextCell: UICollectionViewCell {
    
    let textLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                textLabel.textColor = UIColor(hexString: "#FF4766")
                textLabel.font = UIFont(name: textLabel.font.fontName, size: 14)
            } else {
                textLabel.textColor = UIColor(hexString: "#FFFFFF")
                textLabel.font = UIFont(name: textLabel.font.fontName, size: 12)
            }
        }
    }
    
}
    
    
    


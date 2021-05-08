//
//  SWBgColorView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import UIKit


class SWBgColorView: UIView {

    let bgView = UIView()
    var collection: UICollectionView!
    var didSelectColorBlock: ((_ color: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#F1F1EF")
        setupView()
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        collection.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

}

extension SWBgColorView {
    func setupView() {
        backgroundColor = .clear
        bgView.backgroundColor = .clear
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.left.top.bottom.right.equalToSuperview()
        }
         
        
        
    }
    
    func setupCollection() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        bgView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        collection.register(cellWithClass: SWColorCell.self)
    }
    
}
    
extension SWBgColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SWColorCell.self, for: indexPath)
        let item = DataManager.default.bgColors[indexPath.item]
        cell.colorView.backgroundColor = UIColor(hexString: item)
        
        if item.contains("000000") {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(hexString: "#FFFFFF")?.cgColor
        } else {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.bgColors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWBgColorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 24, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
}

extension SWBgColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = DataManager.default.bgColors[indexPath.item]
        didSelectColorBlock?(color)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

    

class SWColorCell: UICollectionViewCell {
    
    let colorView: UIView = UIView()
    let selectView: UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
        
        selectView.layer.borderWidth = 1
        selectView.layer.borderColor = UIColor(hexString: "#FF4766")?.cgColor
        selectView.image = UIImage(named: "")
        selectView.isHidden = true
        addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(-3)
            $0.right.bottom.equalToSuperview().offset(3)
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            selectView.isHidden = !isSelected
            if isSelected {
                
            } else {
                
            }
        }
    }
    
}
    
    
    


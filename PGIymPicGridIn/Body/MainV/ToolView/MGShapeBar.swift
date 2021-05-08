//
//  MGShapeBar.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit

class MGShapeBar: UIView {
    
    var collection: UICollectionView!
    var didSelectShapeBlock: ((_ item: ShapeItem) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
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

extension MGShapeBar {
    func setupView() {
        
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
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        collection.register(cellWithClass: MGShapeCell.self)
    }
}

extension MGShapeBar {
    
    
}

extension MGShapeBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MGShapeCell.self, for: indexPath)
        let shape = DataManager.default.shapeList[indexPath.item]
        
        cell.contentImageV.image = UIImage(named: shape.thumb ?? "")
        
        if shape.isPro ?? false {
            cell.proImageV.isHidden = false
        } else {
            cell.proImageV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.shapeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MGShapeBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension MGShapeBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shape = DataManager.default.shapeList[indexPath.item]
        didSelectShapeBlock?(shape)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class MGShapeCell: UICollectionViewCell {
    
    let contentImageV: UIImageView = UIImageView()
    let selectView: UIImageView = UIImageView()
    let proImageV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        addSubview(contentImageV)
        contentImageV.contentMode = .scaleAspectFill
        contentImageV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        selectView.layer.borderWidth = 1
        selectView.layer.borderColor = UIColor(hexString: "#FF4766")?.cgColor
        
        selectView.isHidden = true
        addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        proImageV.image = UIImage(named: "grid_icon_vip")
        proImageV.isHidden = true
        addSubview(proImageV)
        proImageV.snp.makeConstraints {
            $0.centerX.equalTo(contentImageV.snp.right)
            $0.centerY.equalTo(contentImageV.snp.top)
            $0.width.height.equalTo(15)
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

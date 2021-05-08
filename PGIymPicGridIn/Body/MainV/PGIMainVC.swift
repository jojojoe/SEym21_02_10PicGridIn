//
//  PGIMainVC.swift
//  PGIymPicGridIn
//
//  Created by JOJO on 2021/4/28.
//

import UIKit
import SwifterSwift
import SnapKit
import Photos
import DeviceKit

var previewWidth: CGFloat = 330


// he /*
//extension PGIMainVC: HightLigtingHelperDelegate {
//
//    func open(isO: Bool) {
//        debugPrint("isOpen = \(isO)")
//    }
//
//    func open() -> UIButton? {
//        let coreButton = UIButton()
//        coreButton.setImage(UIImage(named: "li\("kes_btn_grid_ic")"), for: .normal)
//        coreButton.backgroundColor = .clear
//        coreButton.addTarget(self, action: #selector(coreButtonClick(button:)), for: .touchUpInside)
//        self.view.addSubview(coreButton)
//        coreButton.snp.makeConstraints { (make) in
//            make.width.equalTo(624/2)
//            make.height.equalTo(216/2)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
//            make.centerX.equalTo(self.view)
//        }
//
//        return coreButton
//    }
//
//    @objc func coreButtonClick(button: UIButton) {
//        HightLigtingHelper.default.present()
//    }
//
//    func preparePopupKKAd(placeId: String?, placeName: String?) {
//
//    }
//
//
//    func showAd(type: Int, userId: String?, source: String?, complete: @escaping ((Bool, Bool, Bool) -> Void)) {
//        var adType:String = ""
//        switch type {
//        case 0:
//            adType = "KKAd"
//        case 1:
//            adType = "interstitial Ad"
//        case 2:
//            adType = "reward Video Ad"
//        default:
//            break
//        }
//    }
//}

// he */

class PGIMainVC: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FFDC46")
        setupView()
        
    }
    
    
    
    

}

extension PGIMainVC {
    func setupView() {
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.text = "Post Grids"
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(22)
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(1)
        }
        // store btn
        let storeBtn = UIButton(type: .custom)
        view.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.height.equalTo(44)
        }
        storeBtn.setImage(UIImage(named: "home_icon_store"), for: .normal)
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        //
        let settingBtn = UIButton(type: .custom)
        view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.right.equalTo(storeBtn.snp.left).offset(-5)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.height.equalTo(44)
        }
        settingBtn.setImage(UIImage(named: "home_icon_setting"), for: .normal)
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        let contentImgV = UIImageView(image: UIImage(named: "home_img"))
        view.addSubview(contentImgV)
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(43)
            $0.right.equalToSuperview()
            $0.left.equalTo(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        //780 × 954
        //
        let selectPhotoBtn = UIButton(type: .custom)
        selectPhotoBtn.backgroundColor = .black
        selectPhotoBtn.layer.cornerRadius = 6
        selectPhotoBtn.setImage(UIImage(named: "home_icon_add"), for: .normal)
        view.addSubview(selectPhotoBtn)
        selectPhotoBtn.snp.makeConstraints {
            $0.top.equalTo(contentImgV.snp.bottom).offset(40)
            $0.right.equalTo(-24)
            $0.width.equalTo(170)
            $0.height.equalTo(48)
        }
        selectPhotoBtn.addTarget(self, action: #selector(photoBtnClick(sender:)), for: .touchUpInside)
        //
        let selectPhotoLabel = UILabel()
        view.addSubview(selectPhotoLabel)
        selectPhotoLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        selectPhotoLabel.text = "Select Photo"
        selectPhotoLabel.textColor = UIColor.black
        selectPhotoLabel.snp.makeConstraints {
            $0.centerY.equalTo(selectPhotoBtn)
            $0.right.equalTo(selectPhotoBtn.snp.left).offset(-27)
            $0.height.greaterThanOrEqualTo(1)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
        let left: CGFloat = (UIScreen.main.bounds.width - (56 * 3) - 1) / 4
        // grid btn
        let gridBtn = MGMainBottonBtn(iconName: "home_icon_grid", name: "Grid")
        view.addSubview(gridBtn)
        gridBtn.addTarget(self, action: #selector(gridBtnClick), for: .touchUpInside)
        gridBtn.snp.makeConstraints {
            $0.left.equalTo(left)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.equalTo(56)
            $0.height.equalTo(90)
        }
        
        // shape btn
        let shapeBtn = MGMainBottonBtn(iconName: "home_icon_shape", name: "Shape")
        view.addSubview(shapeBtn)
        shapeBtn.addTarget(self, action: #selector(shapeBtnClick), for: .touchUpInside)
        shapeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(gridBtn)
            $0.width.equalTo(56)
            $0.height.equalTo(90)
        }
        
        // edit btn
        let editBtn = MGMainBottonBtn(iconName: "home_icon_edit", name: "Edit")
        view.addSubview(editBtn)
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        editBtn.snp.makeConstraints {
            $0.right.equalTo(-left)
            $0.bottom.equalTo(gridBtn)
            $0.width.equalTo(56)
            $0.height.equalTo(90)
        }
        
        
    }
    
    
}


extension PGIMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        
        let settingView = PGISettingVC()
        self.navigationController?.pushViewController(settingView)
        
        
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        let storeVC = PGIStoreVC()
        self.navigationController?.pushViewController(storeVC)
    }
    
    @objc func photoBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
    @objc func gridBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
    @objc func shapeBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
    @objc func editBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
}

extension PGIMainVC {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                    
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                case .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                default: break
                }
            }
        }
    }
    
    
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showEditVC(image: UIImage) {
        let editVC = PGIEditVC(image: image)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
}

extension PGIMainVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

class MGMainBottonBtn: UIControl {
    
    let iconImageV = UIImageView()
    let nameLabel = UILabel()
    
    let iconName: String
    let name: String
    
    override init(frame: CGRect) {
        self.iconName = ""
        self.name = ""
        super.init(frame: frame)
        
        setupView()
    }
    
    init(iconName: String, name: String) {
        self.iconName = iconName
        self.name = name
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconImageV.image = UIImage(named: iconName)
        iconImageV.contentMode = .scaleAspectFit
        addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        //
        nameLabel.text = name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        nameLabel.textColor = UIColor(hexString: "#000000")
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageV.snp.bottom).offset(6)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        
    }
    
}


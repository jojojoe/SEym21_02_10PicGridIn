//
//  PGISaveVC.swift
//  PGIymPicGridIn
//
//  Created by JOJO on 2021/4/29.
//

import UIKit
import NoticeObserveKit
import Photos

class PGISaveVC: UIViewController {
    private var pool = Notice.ObserverPool()
    let backBtn = UIButton(type: .custom)
    let topCoinLabel = UILabel()
    let canvasView = UIView()
    let contentImageView = UIImageView()
    var bigImage: UIImage
    var previewImage: UIImage
    var coinAlertBgView = UIView()
    var isPro: Bool = false
    
    
    init(bigImage_save: UIImage, previewImage_small: UIImage, isPro: Bool) {
        self.isPro = isPro
        self.bigImage = bigImage_save
        self.previewImage = previewImage_small
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#000000")
        addNotificationObserver()
        setupView()
    }
    
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(CoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
         
    }

    
    func setupView() {
     
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "grid_icon_return"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        // canvasView
        canvasView.backgroundColor = .clear
        view.addSubview(canvasView)
        canvasView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-200)
//            $0.width.height.equalTo(previewWidth)
        }
        
        
        contentImageView.image = previewImage
        view.addSubview(contentImageView)
        contentImageView.contentMode = .scaleAspectFit
        canvasView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(0)
            $0.width.height.equalTo(previewWidth)
        }
        
        // top coin label
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(CoinManager.default.coinCount)"
        
        topCoinLabel.textColor = UIColor(hexString: "#FFDC46")
        topCoinLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
            $0.width.greaterThanOrEqualTo(25)
        }
        
        let coinImageV = UIImageView()
        coinImageV.image = UIImage(named: "store_icon_coin")
        coinImageV.contentMode = .scaleAspectFit
        view.addSubview(coinImageV)
        coinImageV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-4)
            $0.width.height.equalTo(20)
        }
        
        //
        let coinBtn = UIButton(type: .custom)
        view.addSubview(coinBtn)
        coinBtn.snp.makeConstraints {
            $0.centerY.equalTo(coinImageV)
            $0.left.equalTo(coinImageV.snp.left)
            $0.right.equalTo(topCoinLabel.snp.right)
            $0.height.equalTo(34)
        }
        coinBtn.addTarget(self, action: #selector(coinStoreBtnClick(sender:)), for: .touchUpInside)
        
        // save btn
        let saveBtn = UIButton(type: .custom)
        saveBtn.backgroundColor = UIColor(hexString: "#FFDC46")
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor.black, for: .normal)
        saveBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(canvasView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(221)
            $0.height.equalTo(44)
        }
        saveBtn.layer.cornerRadius = 6
        saveBtn.layer.masksToBounds = true
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        
       // top pro alert
        setupTopProAlertView()
        
        
    }
    
    func setupTopProAlertView() {
        let topProAlertBgView = UIView()
        canvasView.addSubview(topProAlertBgView)
        topProAlertBgView.backgroundColor = .clear
        topProAlertBgView.snp.makeConstraints {
//            $0.right.equalTo(contentImageView)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(8)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        
        let topProAlertLabel = UILabel()
        topProAlertLabel.textColor = UIColor(hexString: "#FFDC46")
        topProAlertLabel.textAlignment = .center
        topProAlertLabel.text = "Current is Purchase Item"
        topProAlertLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
        
        topProAlertBgView.addSubview(topProAlertLabel)
        topProAlertLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        // status
        topProAlertBgView.isHidden = !self.isPro
        
    }
     
    @objc func saveBtnClick(sender: UIButton) {
        
        if isPro {
            
            if CoinManager.default.coinCount >= CoinManager.default.coinCostCount {
                showCoinPurchaseAlertView()
//                showAlert(title: "", message: "Save and cost \(CoinManager.default.coinCostCount) Coins.", buttonTitles: ["Cancel", "Ok"], highlightedButtonIndex: 1) {[weak self] (index) in
//                    guard let `self` = self else {return}
//                    if index == 0 {
//                        // cancel
//
//                    } else {
//                        // ok
//                        DispatchQueue.main.async {
//                            [weak self] in
//                            guard let `self` = self else {return}
//                            self.processImageToAlbum()
//                        }
//                    }
//                }
            } else {
                showAlert(title: "", message: "Coins shortage. Click and Jump to Store", buttonTitles: ["Cancel", "Ok"], highlightedButtonIndex: 1) {[weak self] (index) in
                    guard let `self` = self else {return}
                    if index == 0 {
                        // cancel
                        
                    } else {
                        // ok
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let storeVC = PGIStoreVC()
                            self.navigationController?.pushViewController(storeVC)
                        }
                    }
                }
            }
            
            
        } else {
            processImageToAlbum()
        }
        
        
    }

    
    func processImageToAlbum() {
        HUD.show()
        let imgs = processDivisionImages(originalImage: bigImage)
        saveImgsToAlbum(imgs: imgs)
    }
    
}

extension PGISaveVC {
    func showSaveSuccessAlert() {
        HUD.success("Photos storage successful.")
    }
    func showCoinPurchaseAlertView() {
        coinAlertBgView = UIView()
        coinAlertBgView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.addSubview(coinAlertBgView)
        coinAlertBgView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
            
        let bgBtn = UIButton(type: .custom)
        coinAlertBgView.addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(coinAlertBgViewBtnClick(sender:)), for: .touchUpInside)
        //
        let contentBgView = UIView()
        contentBgView.backgroundColor = .white
        contentBgView.layer.cornerRadius = 12
        coinAlertBgView.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.width.equalTo(354)
            $0.height.equalTo(274)
        }
        //
        let alertTitleLabel = UILabel()
        alertTitleLabel.numberOfLines = 2
        contentBgView.addSubview(alertTitleLabel)
        alertTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        alertTitleLabel.textColor = .black
        alertTitleLabel.text = "Save and cost \(CoinManager.default.coinCostCount) Coins."
        alertTitleLabel.textAlignment = .center
        alertTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(75)
            $0.width.equalTo(174)
            $0.height.equalTo(70)
        }
        //
        let alertOkBtn = UIButton(type: .custom)
        contentBgView.addSubview(alertOkBtn)
        alertOkBtn.snp.makeConstraints {
            $0.bottom.equalTo(-42)
            $0.left.equalTo(24)
            $0.height.equalTo(58)
            $0.width.equalTo(145)
        }
        alertOkBtn.setTitle("OK", for: .normal)
        alertOkBtn.setTitleColor(.black, for: .normal)
        alertOkBtn.backgroundColor = UIColor(hexString: "#FFDC46")
        alertOkBtn.layer.cornerRadius = 6
        alertOkBtn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        alertOkBtn.addTarget(self, action: #selector(coinAlertOkBtnClick(sender:)), for: .touchUpInside)
        //
        let alertCancelBtn = UIButton(type: .custom)
        contentBgView.addSubview(alertCancelBtn)
        alertCancelBtn.snp.makeConstraints {
            $0.bottom.equalTo(-42)
            $0.right.equalTo(-24)
            $0.height.equalTo(58)
            $0.width.equalTo(145)
        }
        alertCancelBtn.setTitle("Cancel", for: .normal)
        alertCancelBtn.setTitleColor(.white, for: .normal)
        alertCancelBtn.backgroundColor = UIColor(hexString: "#FFDC46")
        alertCancelBtn.layer.cornerRadius = 6
        alertCancelBtn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        alertCancelBtn.addTarget(self, action: #selector(coinAlertCancelBtnClick(sender:)), for: .touchUpInside)
        //
        
        
    }
    @objc func coinAlertBgViewBtnClick(sender: UIButton) {
        coinAlertBgView.removeFromSuperview()
    }
    @objc func coinAlertOkBtnClick(sender: UIButton) {
        coinAlertBgView.removeFromSuperview()
        self.processImageToAlbum()
    }
    @objc func coinAlertCancelBtnClick(sender: UIButton) {
        coinAlertBgView.removeFromSuperview()
    }
    @objc func coinStoreBtnClick(sender: UIButton) {
        let storeVC = PGIStoreVC()
        self.navigationController?.pushViewController(storeVC)
    }
}

extension PGISaveVC {
    
    func saveImgsToAlbum(imgs: [UIImage]) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {

                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
//            showPhotoNoAuthorizedAlert()
        }
        
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
                if self.isPro {
                    CoinManager.default.costCoin(coin: CoinManager.default.coinCostCount)
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    
    func processDivisionImages(originalImage: UIImage) -> [UIImage] {
        
        
        let widthLengthCount = 3
        let heightLengthCount = 3
        let devideLineWidth = 0

        var contentSubViewRect: [CGRect] = []
        
        let perWidthLengh: CGFloat = CGFloat(Int(originalImage.size.width) - (widthLengthCount - 1) * devideLineWidth) / CGFloat(widthLengthCount)
        let perHeightLengh: CGFloat = CGFloat(Int(originalImage.size.height) - (heightLengthCount - 1) * devideLineWidth) / CGFloat(heightLengthCount)
        
        let allImageCount = widthLengthCount * heightLengthCount;
        
        for index in 0..<allImageCount {
            let hangCount = index / widthLengthCount;
            let lieCount = index % heightLengthCount;
            let x: CGFloat = perWidthLengh * CGFloat(lieCount) + CGFloat(devideLineWidth) * CGFloat(lieCount)
            let y: CGFloat = perHeightLengh * CGFloat(hangCount) + CGFloat(devideLineWidth) * CGFloat(hangCount)
            let contentImageViewRect = CGRect.init(x: x, y: y, width: perWidthLengh, height: perHeightLengh)
            
            contentSubViewRect.append(contentImageViewRect)
        }
        let divisionSize = CGSize.init(width: perWidthLengh, height: perHeightLengh)
        var divisionImgs: [UIImage] = []
        for itemRect in contentSubViewRect {
            
            UIGraphicsBeginImageContextWithOptions(divisionSize, false, UIScreen.main.scale)
            // Always remember to close the image context when leaving
            defer { UIGraphicsEndImageContext() }
            
            originalImage.draw(in: CGRect(x: -itemRect.origin.x, y: -itemRect.origin.y, width: originalImage.size.width, height: originalImage.size.height))
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                // Set the textColor to the new created gradient color
                divisionImgs.append(image)
            }
        }
        return divisionImgs
    }
}


extension PGISaveVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}






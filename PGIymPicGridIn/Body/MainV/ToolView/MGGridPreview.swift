//
//  MGGridPreview.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/7.
//

import UIKit

class MGGridPreview: UIView {

    var contentImage: UIImage
    var widthLengthCount: Int = 3
    var heightLengthCount: Int = 3
    
    var previewImageView: UIImageView = UIImageView()
    
    var coverViews: [UIView] = []
    var overlayerLineViews: [UIView] = []
    
    var currentAlpha: CGFloat? = 0
    var currentColor: String? = "#000000"
    var currentGridList: [Int]? = []
    
    
    
    init(frame: CGRect, image: UIImage, widthCount: Int = 3, heightCount: Int = 3) {
        
        self.contentImage = image
        self.widthLengthCount = widthCount
        self.heightLengthCount = heightCount
        super.init(frame: frame)
        setupView()
        setupCoversView()
        
        updateCoverView(colorStr: "#000000", alpha: 0.7, indexs: [])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MGGridPreview {
    func updateCoverView(colorStr: String, alpha: CGFloat, indexs: [Int]) {
        
        currentAlpha = alpha
        currentColor = colorStr
        currentGridList = indexs
        
        for (i, subView) in coverViews.enumerated() {
            if indexs.contains(i) {
                subView.backgroundColor = UIColor(hexString: colorStr)
                subView.alpha = alpha
            } else {
                subView.alpha = 0
            }
        }
    }
    
    func updateContentImage(img: UIImage) {
        contentImage = img
        previewImageView.image = img
    }
    
    func showLineViewsStatus(isShow: Bool) {
        for lineView in overlayerLineViews {
            lineView.isHidden = !isShow
        }
    }
}

extension MGGridPreview {
    func setupView() {
        addSubview(previewImageView)
        previewImageView.clipsToBounds = true
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        previewImageView.image = contentImage
        
        
    }
    
    func setupCoversView() {
        
        let perWidthLengh: CGFloat = CGFloat(Int(bounds.width)) / CGFloat(widthLengthCount)
        let perHeightLengh: CGFloat = CGFloat(Int(bounds.height)) / CGFloat(heightLengthCount)
        
        let allImageCount = widthLengthCount * heightLengthCount;
        
        for index in 0..<allImageCount {
            let hangCount = index / widthLengthCount;
            let lieCount = index % heightLengthCount;
            let x: CGFloat = perWidthLengh * CGFloat(lieCount)
            let y: CGFloat = perHeightLengh * CGFloat(hangCount)
            let contentCoverRect = CGRect.init(x: x, y: y, width: perWidthLengh, height: perHeightLengh)
            
            let coverView = UIView()
            addSubview(coverView)
            coverView.frame = contentCoverRect
            coverViews.append(coverView)
        }
        
        let lineWidth: CGFloat = 3
        let widthLineCount = widthLengthCount - 1
        let heightLineCount = heightLengthCount - 1
        
        overlayerLineViews = []
        for index in 0..<widthLineCount {
            let x = perWidthLengh * CGFloat(index + 1) - (lineWidth/2)
            let shuView = UIView()
            shuView.backgroundColor = UIColor.white
            addSubview(shuView)
            shuView.frame = CGRect(x: x, y: 0, width: lineWidth, height: bounds.height)
            overlayerLineViews.append(shuView)
        }
        
        for index in 0..<heightLineCount {
            let y = perHeightLengh * CGFloat(index + 1) - (lineWidth/2)
            let hengView = UIView()
            hengView.backgroundColor = UIColor.white
            addSubview(hengView)
            hengView.frame = CGRect(x: 0, y: y, width: bounds.width, height: lineWidth)
            overlayerLineViews.append(hengView)
        }
        
        
    }
    
    
}






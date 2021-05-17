//
//  UIImageViewExtension.swift
//  Alamofire
//
//  Created by 薛忱 on 2020/7/28.
//

import UIKit
import Kingfisher

extension UIImageView {
    @discardableResult func imageForName(name: String?) -> Self {
        
        guard let imageName = name else {
            return self
        }
        
        image = UIImage(named: imageName) ?? UIImage(withBundleName: imageName)
        return self
    }
    
    func setKfImage(imagePath: String) {
        print("imagePath: \(URL.init(string: imagePath)!)")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL.init(string: imagePath))
        let cache = KingfisherManager.shared.cache
        cache.clearDiskCache()
        cache.clearMemoryCache()
        cache.cleanExpiredDiskCache()
    }
}

//
//  UIImageExtension.swift
//  Alamofire
//
//  Created by 薛忱 on 2020/7/28.
//

import UIKit

extension UIImage {
    convenience init?(withBundleName name: String) {
        let path = Bundle.main.path(forResource: "GetRichEveryDay", ofType: "bundle") ?? ""
        self.init(named: name, in: Bundle(path: path), compatibleWith: nil)
    }
    
    static func named(name: String?) -> UIImage? {
        guard let imageValue = name else { return nil }
        return UIImage(named: imageValue) ?? UIImage.init(withBundleName: imageValue)
    }
    
}

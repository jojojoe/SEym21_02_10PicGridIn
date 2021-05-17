//
//  UILabelExtension.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/3.
//

import UIKit

//class UILabelExtension: NSObject {
//
//}

extension UILabel {
    /**  改变行间距  */
    func changeLineSpace(space:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: .init(location: 0, length: text!.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }

    /**  改变字间距  */
    func changeWordSpace(space:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern:space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: .init(location: 0, length: text!.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }

    /**  改变字间距和行间距  */
    func changeSpace(lineSpace:CGFloat, wordSpace:CGFloat) {
        if self.text == nil || self.text == "" {
            return
        }
        let text = self.text
        let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern:wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: .init(location: 0, length: text!.count))
        self.attributedText = attributedString
        self.sizeToFit()

    }
}

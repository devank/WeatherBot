//
//  PaddedLabel.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Perleybrook Labs LLC. All rights reserved.
//

import UIKit

@IBDesignable
class PaddedLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += bottomInset + topInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

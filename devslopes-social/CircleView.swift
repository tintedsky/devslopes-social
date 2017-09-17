//
//  CircleView.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-17.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.cornerRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = self.frame.width / 2
//    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }
}

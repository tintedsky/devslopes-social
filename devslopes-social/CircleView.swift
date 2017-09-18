//
//  CircleView.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-17.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit

class CircleView: UIImageView { 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}

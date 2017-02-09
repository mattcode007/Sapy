//
//  Navi.swift
//  Sapy
//
//  Created by Matteo Cesari on 09/02/17.
//  Copyright © 2017 Matteo Cesari. All rights reserved.
//

import UIKit

class Navi: UINavigationBar {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.gray.cgColor;
        self.layer.borderWidth = 0;
    }
    

}

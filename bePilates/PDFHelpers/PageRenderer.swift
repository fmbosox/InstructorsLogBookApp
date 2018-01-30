//
//  pageRenderer.swift
//  bePilates
//
//  Created by Felipe Montoya on 1/9/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class PageRenderer: UIPrintPageRenderer {
     let pageFrame = CGRect(x: 0.0, y: 0.0, width: 595.0, height: 811.8)
    
    override init() {
        super.init()
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
    }
}

//
//  File.swift
//  
//
//  Created by BrainX 3096 on 17/02/2022.
//

import Foundation
import UIKit

//MARK: - UIImage

extension UIImage {
    enum SupportedImageType: String {
        case png = "png"
        case pdf = "pdf"
    }
    
    convenience init?(packageResource name: String, ofType type: SupportedImageType) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type.rawValue) else {
            self.init(named: name)
            return
        }
        self.init(contentsOfFile: path)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type.rawValue),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}

//MARK: - UIColor

extension UIColor {
    convenience init(_ value: Int) {
        let r = CGFloat(value >> 16 & 0xFF) / 255.0
        let g = CGFloat(value >> 8 & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

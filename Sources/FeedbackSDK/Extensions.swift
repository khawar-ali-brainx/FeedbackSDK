//
//  File.swift
//  
//
//  Created by BrainX 3096 on 17/02/2022.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type) else {
            self.init(named: name)
            return
        }
        self.init(contentsOfFile: path)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
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

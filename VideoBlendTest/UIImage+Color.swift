//
//  UIImage+Color.swift
//  VideoBlendTest
//
//  Created by Andreas Hörberg on 2019-01-30.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

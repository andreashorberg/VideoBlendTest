//
//  UIImage+Tint.swift
//  VideoBlendTest
//
//  Created by Andreas Hörberg on 2019-01-30.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import UIKit

extension UIImage {
    func tint(tintColor: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            context.setBlendMode(.multiply)
            tintColor.setFill()
            context.fill(rect)
        }
    }

    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

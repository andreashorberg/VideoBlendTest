//
//  TintFilter.swift
//  VideoBlendTest
//
//  Created by Andreas Hörberg on 2019-01-30.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import CoreImage
import UIKit

class TintFilter: CIFilter {

    @objc dynamic var inputImage: CIImage?

    var color = UIColor.black
    var colorBlendFactor: CGFloat = 1.0

    public init(color: UIColor, colorBlendFactor: CGFloat) {
        super.init()
        self.color = color
        self.colorBlendFactor = colorBlendFactor
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func computeBlendComponent(_ component: CGFloat) -> CGFloat {
        return 1.0 - (colorBlendFactor * (1.0 - component))
    }

    override open var outputImage: CIImage? {

        guard let inputImage = self.inputImage else {
            return nil
        }

        let colorGenerator = CIFilter(name:"CIConstantColorGenerator")

        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness:&brightness, alpha:&alpha)
        brightness += colorBlendFactor - 1.0
        brightness = max(min(brightness, 1.0), 0.0)
        let newColor = UIColor(hue: hue, saturation: saturation, brightness:brightness, alpha:alpha)

        let inputColor = CIColor(cgColor: newColor.cgColor)
        colorGenerator?.setValue(inputColor, forKey: "inputColor")

        guard var colorOutputImage = colorGenerator?.outputImage else {
            return nil
        }

        colorOutputImage = CIImage(color: CIColor(color: self.color.withAlphaComponent(self.colorBlendFactor)))

        return colorOutputImage.applyingFilter("CIMultiplyCompositing", parameters: ["inputBackgroundImage": inputImage]).applyingFilter("CIMultiplyBlendMode", parameters: ["inputBackgroundImage": inputImage])
    }
}

//
//  UIImage+Extension.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 28/06/21.
//

import UIKit

// code from: https://stackoverflow.com/a/33675160/6454864
// Create UIImage with solid color in Swift
public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

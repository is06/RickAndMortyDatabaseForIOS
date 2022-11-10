//
//  UIImage+Resize.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 10/11/2022.
//  Based on work by Moritz Philip Recke
//  https://www.createwithswift.com/uiimage-resize-resizing-an-uiimage/
//

import UIKit

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

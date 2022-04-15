//
//  UIImageExtension.swift
//  Recipe
//
//  Created by Justin on 14/04/2022.
//

import UIKit

extension UIImage {
    func data() -> Data {
        var imageData = self.pngData()
        // Resize the image if it exceeds the 2MB API limit
        if (imageData?.count)! > 2097152 {
            let oldSize = size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width *
                800)
            let newImage = resizeImage(targetSize: newSize)
            imageData = newImage.jpegData(compressionQuality: 0.7)
        }
        return imageData!
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

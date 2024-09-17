//
//  Util.swift
//  FBDictDemo
//
//  Created by Rudolf Farkas on 17.09.24.
//

import UIKit

func printt(_ items: String..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = formatter.string(from: currentTime)
        print("\(timestamp)", items.joined(separator: separator), separator: separator, terminator: terminator)
    #endif
}

extension UIImage {
    func cropToSquare() -> UIImage? {
        guard let cgImage else { return nil }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        var cropRect: CGRect

        if width > height {
            // Crop the width to match the height
            let xOffset = (width - height) / 2
            cropRect = CGRect(x: xOffset, y: 0, width: height, height: height)
        } else if height > width {
            // Crop the height to match the width
            let yOffset = (height - width) / 2
            cropRect = CGRect(x: 0, y: yOffset, width: width, height: width)
        } else {
            // If the image is already square, no cropping is needed
            return self
        }

        // Perform cropping
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else {
            return nil
        }

        // Return the cropped UIImage, preserving scale and orientation
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}

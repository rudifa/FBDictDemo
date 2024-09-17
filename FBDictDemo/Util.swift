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
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss.SSS"
            return formatter
        }()
        let timestamp = formatter.string(from: currentTime)
        print("\(timestamp)", items.joined(separator: separator), separator: separator, terminator: terminator)
    #endif
}

extension UIImage {
    func cropToSquare() -> UIImage? {
        guard let cgImage else { return nil }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let size = min(width, height)
        let xOffset = (width - size) / 2
        let yOffset = (height - size) / 2
        let cropRect = CGRect(x: xOffset, y: yOffset, width: size, height: size)

        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }

        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}

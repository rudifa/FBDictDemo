//
//  FBDictDemoTests.swift
//  FBDictDemoTests
//
//  Created by Rudolf Farkas on 16.09.24.
//

@testable import FBDictDemo
import UIKit
import XCTest

final class FBDictDemoTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testCropImage() throws {
        let image = generateTestImage()
        let croppedImage = image.cropToSquare()
        XCTAssertNotNil(croppedImage)
        // XCTAssertEqual(croppedImage!.size.width, croppedImage!.size.height)

        print("image.size: \(image.size)")
        print("croppedImage.size: \(croppedImage!.size)")
    }

    func generateTestImage() -> UIImage {
        let size = CGSize(width: 750, height: 1000)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}

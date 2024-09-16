//
//  UIImageCodable.swift
//  test-pkg-access
//
//  Created by Rudolf Farkas on 16.09.24.
//

import UIKit

struct UIImageCodable: Codable {
    let image: UIImage

    enum CodingKeys: String, CodingKey {
        case imageData
    }

    init(image: UIImage) {
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageData = try container.decode(Data.self, forKey: .imageData)
        guard let image = UIImage(data: imageData) else {
            throw DecodingError.dataCorruptedError(forKey: .imageData, in: container, debugDescription: "Data could not be converted to UIImage")
        }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let imageData = image.pngData() else {
            throw EncodingError.invalidValue(image, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "UIImage could not be converted to Data"))
        }
        try container.encode(imageData, forKey: .imageData)
    }
}

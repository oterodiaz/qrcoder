//
//  CreateTempFile.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-22.
//

import SwiftUI

func createTempFile(from nsImage: NSImage) -> URL? {
    let representation = NSBitmapImageRep(data: nsImage.tiffRepresentation!)
    guard let pngData = representation?.representation(using: .png, properties: [:]) else {
        return nil
    }

    let url = URL(filePath: NSTemporaryDirectory()).appending(component: "qrcode.png")

    do {
        try pngData.write(to: url)
    } catch {
        print(error)
        return nil
    }

    return url
}

//
//  SaveToFile.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-31.
//

import SwiftUI

func saveToFile(_ nsImage: NSImage) {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.png]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = String(localized: "Save")
    savePanel.message = String(localized: "Choose where to store the QR code.")
    savePanel.nameFieldLabel = String(localized: "Image file name:")

    savePanel.beginSheetModal(for: NSApplication.shared.keyWindow!) { response in
        guard response == .OK else {
            return
        }

        let path = savePanel.url!
        let representation = NSBitmapImageRep(data: nsImage.tiffRepresentation!)
        let pngData = representation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path)
        } catch {
            print(error)
        }
    }
}

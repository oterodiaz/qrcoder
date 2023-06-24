//
//  Preview-ViewModel.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-06-04.
//

import SwiftUI
import UniformTypeIdentifiers

extension Preview {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var nsImage: NSImage?
        @Published var isDraggingEnabled: Bool

        let cornerRadius: CGFloat = 6
        let spacing: CGFloat = 12
        let width: CGFloat = 350

        init(nsImage: NSImage? = nil, isDraggingEnabled: Bool = true) {
            self.nsImage = nsImage
            self.isDraggingEnabled = isDraggingEnabled
        }

        func handleDrag() -> NSItemProvider {
            guard let nsImage = nsImage else {
                return NSItemProvider()
            }

            guard let url = createTempFile(from: nsImage) else {
                return NSItemProvider()
            }

            let provider = NSItemProvider(item: url as NSSecureCoding,
                                          typeIdentifier: UTType.fileURL.identifier)

            provider.suggestedName = url.lastPathComponent

            return provider
        }
    }
}

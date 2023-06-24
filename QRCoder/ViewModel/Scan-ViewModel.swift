//
//  Scan-ViewModel.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-31.
//

import SwiftUI

extension Scan {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var qrCode: QRCode
        @Published var isDraggingFile: Bool
        @Published var isPressingOption: Bool
        @Published var isContentScanned: Bool
        @Published var isShowingAlert: Bool

        var ciImage: CIImage? {
            didSet {
                if let content = scan() {
                    qrCode.message = content
                    isContentScanned = true
                } else {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        Task { @MainActor in
                            self.isShowingAlert = true
                        }
                    }
                }
            }
        }

        init(qrCode: QRCode = QRCode(),
             isDraggingFile: Bool = false,
             isPressingOption: Bool = false,
             isContentScanned: Bool = false,
             isShowingAlert: Bool = false) {

            self.qrCode = qrCode
            self.isDraggingFile = isDraggingFile
            self.isPressingOption = isPressingOption
            self.isContentScanned = isContentScanned
            self.isShowingAlert = isShowingAlert
        }

        func copyToClipboard() {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(qrCode.message, forType: .string)
        }

        func reset() {
            isContentScanned = false
            qrCode.message = ""
            isDraggingFile = false
            isPressingOption = false
            isShowingAlert = false
        }

        func handleDrop(_ providers: [NSItemProvider]) -> Bool {
            if let provider = providers.first {
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let imageData = data,
                       let ciImage = CIImage(data: imageData) {
                        Task { @MainActor in
                            self.ciImage = ciImage
                        }
                    }
                }
                return true
            }
            return false
        }

        func observeOptionKeyPresses() {
            guard !isContentScanned else {
                return
            }

            NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
                if event.modifierFlags.contains(.option) == true {
                    self.isPressingOption = true
                } else {
                    if self.isPressingOption == true {
                        self.isPressingOption = false
                    }
                }

                return event
            }
        }

        func scan() -> String? {
            guard let ciImage = self.ciImage else {
                return nil
            }

            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: AppState.context)!
            let features = qrDetector.features(in: ciImage)

            guard !features.isEmpty else {
                return nil
            }

            return (features.first! as! CIQRCodeFeature).messageString
        }

        func openFile() {
            let openPanel = NSOpenPanel()
            openPanel.canChooseFiles = true
            openPanel.canChooseDirectories = false
            openPanel.resolvesAliases = true
            openPanel.allowsMultipleSelection = false
            openPanel.canCreateDirectories = false
            openPanel.allowedContentTypes = [.image]
            openPanel.isExtensionHidden = false
            openPanel.title = String(localized: "Select an Image")
            openPanel.message = String(localized: "Select an image containing a QR code")

            openPanel.beginSheetModal(for: NSApplication.shared.keyWindow!) { response in
                guard response == .OK else {
                    return
                }

                guard let url = openPanel.url else {
                    return
                }

                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }

                self.ciImage = CIImage(data: imageData)
            }
        }

        func takeScreenshot(of type: ScreenshotType = .screen) {
            let filename = UUID().uuidString
            let url = URL(filePath: NSTemporaryDirectory()).appending(component: filename)

            let process = Process()

            switch type {
            case .screen:
                process.arguments = ["screencapture", "-x", url.path(percentEncoded: false)]
            case .area:
                process.arguments = ["screencapture", "-i", url.path(percentEncoded: false)]
            }

            process.executableURL = URL(filePath: "/usr/bin/env")

            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                return
            }

            guard FileManager.default.fileExists(atPath: url.path()) else {
                return
            }

            guard let imageData = try? Data(contentsOf: url) else {
                return
            }

            try? FileManager.default.removeItem(at: url)

            self.ciImage = CIImage(data: imageData)
        }

        enum ScreenshotType {
            case screen, area
        }
    }
}

//
//  QRCode.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-16.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCode: Equatable {
    var message: String = ""
    var resolution: CGSize = .init(width: 512, height: 512)
    var correctionLevel: CorrectionLevel = .medium
    var style = Style()

    var encodedMessage: Data? {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        let encodedMessage: Data?

        if let data = message.data(using: .isoLatin1) {
            encodedMessage = data
        } else if let data = message.data(using: .utf8) {
            encodedMessage = data
        } else {
            encodedMessage = nil
        }

        return encodedMessage
    }

    var nsImage: NSImage? {
        guard let encodedMessage = encodedMessage else {
            return nil
        }

        let generator = CIFilter.qrCodeGenerator()
        generator.message = encodedMessage
        generator.correctionLevel = correctionLevel.rawValue

        guard var ciImage = generator.outputImage else {
            return nil
        }

        // Scale the generated image to a proper resolution
        let scaleX = resolution.width / ciImage.extent.width
        let scaleY = resolution.height / ciImage.extent.height
        ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        if !style.isDefault {
            let extent = ciImage.extent

            if let bg = style.bg.asCIImage(ofSize: extent),
               let fg = style.fg.asCIImage(ofSize: extent),
               let result = ciImage.replace(bg: bg, fg: fg) {
                ciImage = result
            }
        }

        guard let nsImage = ciImage.asNSImage(context: AppState.context) else {
            return nil
        }

        return nsImage
    }

    struct Style: Equatable {
        var bg = Defaults.bg
        var fg = Defaults.fg

        var isDefault: Bool {
            (bg == Defaults.bg) && (fg == Defaults.fg)
        }

        var isDefaultFg: Bool {
            fg == Defaults.fg
        }

        var isDefaultBg: Bool {
            bg == Defaults.bg
        }

        mutating func reset() {
            bg = Defaults.bg
            fg = Defaults.fg
        }

        mutating func resetBg() {
            bg = Defaults.bg
        }

        mutating func resetFg() {
            fg = Defaults.fg
        }

        struct Fill: Equatable {
            var solidColor: CGColor
            var gradientColor0: CGColor
            var gradientColor1: CGColor
            var isGradient: Bool
            var gradientDirection: Direction

            init(solidColor: CGColor = Defaults.fg.solidColor,
                 gradientColor0: CGColor = Defaults.fg.gradientColor0,
                 gradientColor1: CGColor = Defaults.fg.gradientColor1,
                 isGradient: Bool = Defaults.fg.isGradient,
                 gradientDirection: Direction = Defaults.fg.gradientDirection) {

                self.solidColor = solidColor
                self.gradientColor0 = gradientColor0
                self.gradientColor1 = gradientColor1
                self.isGradient = isGradient
                self.gradientDirection = gradientDirection
            }

            func asCIImage(ofSize size: CGRect) -> CIImage? {
                let image: CIImage?

                if isGradient {
                    let linearGradient = CIFilter.linearGradient()
                    linearGradient.color0 = CIColor(cgColor: gradientColor0)
                    linearGradient.color1 = CIColor(cgColor: gradientColor1)

                    lazy var top         = CGPoint(x: size.width / 2, y: size.height)
                    lazy var bottom      = CGPoint(x: size.width / 2, y: 0)
                    lazy var left        = CGPoint(x: 0, y: size.height / 2)
                    lazy var right       = CGPoint(x: size.width, y: size.height / 2)
                    lazy var topLeft     = CGPoint(x: 0, y: size.height)
                    lazy var topRight    = CGPoint(x: size.width, y: size.height)
                    lazy var bottomLeft  = CGPoint(x: 0, y: 0)
                    lazy var bottomRight = CGPoint(x: size.width, y: 0)

                    switch gradientDirection {
                    case .top:
                        linearGradient.point0 = bottom
                        linearGradient.point1 = top
                    case .bottom:
                        linearGradient.point0 = top
                        linearGradient.point1 = bottom
                    case .left:
                        linearGradient.point0 = right
                        linearGradient.point1 = left
                    case .right:
                        linearGradient.point0 = left
                        linearGradient.point1 = right
                    case .topLeft:
                        linearGradient.point0 = bottomRight
                        linearGradient.point1 = topLeft
                    case .topRight:
                        linearGradient.point0 = bottomLeft
                        linearGradient.point1 = topRight
                    case .bottomLeft:
                        linearGradient.point0 = topRight
                        linearGradient.point1 = bottomLeft
                    case .bottomRight:
                        linearGradient.point0 = topLeft
                        linearGradient.point1 = bottomRight
                    }

                    image = linearGradient.outputImage
                } else {
                    let ciColor = CIColor(cgColor: solidColor)
                    image = CIImage(color: ciColor)
                }

                return image?.cropped(to: size)
            }

            enum Direction: String, CaseIterable {
                case top         = "arrow.up"
                case bottom      = "arrow.down"
                case left        = "arrow.left"
                case right       = "arrow.right"
                case topLeft     = "arrow.up.left"
                case topRight    = "arrow.up.right"
                case bottomLeft  = "arrow.down.left"
                case bottomRight = "arrow.down.right"
            }
        }

        private enum Defaults {
            static let bg = Fill(solidColor: .white,
                                 gradientColor0: .init(red: 1, green: 0.87, blue: 0.63, alpha: 1),
                                 gradientColor1: .init(red: 0.54, green: 1, blue: 0.61, alpha: 1),
                                 isGradient: false,
                                 gradientDirection: .bottomLeft)

            static let fg = Fill(solidColor: .black,
                                 gradientColor0: .init(red: 1, green: 0, blue: 0, alpha: 1),
                                 gradientColor1: .init(red: 0, green: 0, blue: 1, alpha: 1),
                                 isGradient: false,
                                 gradientDirection: .topRight)
        }

        static func == (lhs: Style, rhs: Style) -> Bool {
            (lhs.bg == rhs.bg) && (lhs.fg == rhs.fg)
        }
    }
}

fileprivate extension CIImage {
    func asNSImage(context: CIContext) -> NSImage? {
        guard let cgImage = context.createCGImage(self, from: self.extent) else {
            return nil
        }

        let nsImage = NSImage(cgImage: cgImage,
                              size: NSSize(width: cgImage.width,
                                           height: cgImage.height))

        return nsImage
    }

    /// Replace the background (white) and foreground (black) of a QR Code.
    ///
    /// The white background of a regular QR Code image is converted to transparency, leaving the black foreground intact.
    ///
    /// This new image is used as a mask to blend the background and foreground images. Transparent pixels are replaced
    /// by the corresponding pixels of the background image, while non-transparent ones are replaced by those of the
    /// foreground image.
    ///
    /// These background and foreground images are expected to be the same size as the original image, but will in any case
    /// be cropped to its size. They can be single color images, gradients, pictures, or any other kind of image.
    func replace(bg: CIImage, fg: CIImage) -> CIImage? {
        guard let mask = self.withColors(background: .clear, foreground: .black)
        else {
            return nil
        }

        let blendWithMask = CIFilter.blendWithAlphaMask()
        blendWithMask.backgroundImage = bg
        blendWithMask.inputImage = fg
        blendWithMask.maskImage = mask

        let result = blendWithMask.outputImage

        if result?.extent != self.extent {
            return result?.cropped(to: self.extent)
        }

        return result
    }

    /// Use a false color filter to change the color of the background (white) and foreground (black) of a QR Code.
    private func withColors(background: CIColor, foreground: CIColor) -> CIImage? {
        let falseColorFilter = CIFilter.falseColor()
        falseColorFilter.inputImage = self
        falseColorFilter.color0 = foreground // Convert dark tones to foreground color
        falseColorFilter.color1 = background // Convert light tones to background color

        return falseColorFilter.outputImage
    }
}

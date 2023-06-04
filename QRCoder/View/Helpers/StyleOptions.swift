//
//  StyleOptions.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-23.
//

import SwiftUI

struct StyleOptions: View {
    @Binding var style: QRCode.Style

    var body: some View {
        Form {
            Section {
                LayerOptions(for: $style.fg)
            } header: {
                HStack {
                    Text("Foreground")

                    Spacer(minLength: 0)

                    ResetButton {
                        style.resetFg()
                    }
                    .disabled(style.isDefaultFg)
                }
                .font(.body.bold())
            }

            Divider()
                .padding(.vertical, 6)

            Section {
                LayerOptions(for: $style.bg)
            } header: {
                HStack {
                    Text("Background")
                        .font(.body.bold())

                    Spacer(minLength: 0)


                    ResetButton {
                        style.resetBg()
                    }
                    .disabled(style.isDefaultBg)
                }
                .font(.body.bold())
            }

        }
        .padding(12)
    }
}

fileprivate struct LayerOptions: View {
    @Binding var layer: QRCode.Style.Fill

    init(for layer: Binding<QRCode.Style.Fill>) {
        self._layer = layer
    }

    private var colorLabel: String {
        if layer.isGradient {
            return String(localized: "Colors", comment: "Plural for exactly two (2) colors")
        } else {
            return String(localized: "Color")
        }
    }

    var body: some View {
        FormRow(colorLabel) {
            if layer.isGradient {
                HStack {
                    ColorPicker("Gradient Start Color", selection: $layer.gradientColor0)
                    ColorPicker("Gradient End Color", selection: $layer.gradientColor1)
                }
            } else {
                ColorPicker("Solid Color", selection: $layer.solidColor)
            }
        }

        FormRow(String(localized: "Gradient")) {
            Toggle("Gradient", isOn: $layer.isGradient)
                .toggleStyle(.switch)
                .controlSize(.small)
        }

        DirectionPicker(direction: $layer.gradientDirection)
            .disabled(!layer.isGradient)
    }
}

fileprivate struct ResetButton: View {
    let code: () -> Void

    var body: some View {
        Button(role: .destructive) {
            code()
        } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
                .labelStyle(.iconOnly)
        }
        .controlSize(.mini)
        .foregroundColor(.secondary)
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .help("Reset")
    }
}

struct StyleOptions_Previews: PreviewProvider {
    static var previews: some View {
        StyleOptions(style: .constant(QRCode(
            style: .init(bg: .init(solidColor: .white,
                                   gradientColor0: .black,
                                   gradientColor1: .white,
                                   isGradient: true,
                                   gradientDirection: .bottomLeft))).style))
    }
}

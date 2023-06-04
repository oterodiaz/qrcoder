//
//  CustomTextEditor.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-22.
//

import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    @Environment(\.colorScheme) private var colorScheme
    @State private var textHeight: CGFloat = .zero

    let isEditable: Bool

    init(text: Binding<String>, isEditable: Bool = true) {
        self._text = text
        self.isEditable = isEditable
    }

    var body: some View {
        VStack {
            if isEditable {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .font(.body)
            } else {
                ScrollView {
                    TextView(text: $text, textHeight: $textHeight, isEditable: isEditable)
                        .frame(height: textHeight)
                }
            }
        }
        .frame(maxWidth: 512, maxHeight: 256)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(colorScheme == .light ? .white : .clear)
        .background(.selection.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.primary.opacity(0.2), lineWidth: 1)
        }
    }
}

struct CustomTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEditor(text: .constant(""))
            .padding()
    }
}

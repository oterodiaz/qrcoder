//
//  TextView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-27.
//

import SwiftUI

struct TextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var textHeight: CGFloat

    let isEditable: Bool

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.drawsBackground = false
        textView.alignment = .left
        textView.isEditable = isEditable

        let descriptor = NSFontDescriptor
            .preferredFontDescriptor(forTextStyle: .body)

        textView.font = NSFont(descriptor: descriptor, size: 0)

        return textView
    }

    func updateNSView(_ view: NSTextView, context: Context) {
        let textView = view
        textView.string = self.text

        // Set the text attributes of the NSTextStorage instance to match those of the NSTextView
        let textAttributes = textView.typingAttributes
        let attributedString = NSAttributedString(string: text, attributes: textAttributes)

        // Get the size that fits the textView's content
        let textContainer = textView.textContainer!
        let layoutManager = textView.layoutManager!
        textView.textStorage?.setAttributedString(attributedString)

        textView.layoutManager?.replaceTextStorage(textView.textStorage!)

        layoutManager.glyphRange(for: textContainer)

        let size = layoutManager.usedRect(for: textContainer).size

        DispatchQueue.main.async {
            textHeight = size.height
        }

        guard context.coordinator.selectedRanges.count > 0 else {
            return
        }

        textView.selectedRanges = context.coordinator.selectedRanges
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TextView
        var selectedRanges = [NSValue]()

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            selectedRanges = textView.selectedRanges
        }
    }
}

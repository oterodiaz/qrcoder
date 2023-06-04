//
//  FormRow.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-18.
//

import SwiftUI

struct FormRow<Title: View, Content: View>: View {
    private let title: Title
    private let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) where Title == Text {
        self.init {
            Text(verbatim: title)
        } content: {
            content()
        }
    }

    init(@ViewBuilder _ title: () -> Title) where Content == EmptyView {
        self.init {
            title()
        } content: {
            EmptyView()
        }
    }

    init(@ViewBuilder _ title: () -> Title,
         @ViewBuilder content: () -> Content) {

        self.title = title()
        self.content = content()
    }

    var body: some View {
        HStack {
            title

            Spacer()

            content
                .labelsHidden()
                .controlSize(.small)
        }
    }
}

//struct FormBox<Content: View>: View {
//    private let content: Content
//
//    init(@ViewBuilder _ content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        GroupBox {
//            Form {
//                VStack(spacing: 8) {
//                    content
//                }
//            }
//            .padding(6)
//            .labelsHidden()
//        }
//    }
//}

//struct FormBox_Previews: PreviewProvider {
//    static var previews: some View {
//        FormBox {
//            FormRow {
//                Text("Test")
//            } content: {
//                Toggle("", isOn: .constant(true))
//                    .toggleStyle(.switch)
//            }
//
//            Divider()
//
//            FormRow {
//                Text("Test")
//            } content: {
//                ColorPicker("", selection: .constant(.red))
//            }
//
//            Divider()
//
//            FormRow {
//                VStack(alignment: .leading) {
//                    Text("Test")
//                    Text("More info")
//                        .font(.body)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }
//        .padding()
//    }
//}

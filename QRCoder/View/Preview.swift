//
//  Preview.swift
//  QRCoder
//
//  Created by Otero Díaz on 2023-05-18.
//

import SwiftUI

struct Preview: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Image(nsImage: viewModel.nsImage ?? NSImage())
            .resizable()
            .scaledToFit()
            .frame(width: viewModel.width - 2, height: viewModel.width - 2)
            .background {
                Checkerboard(rows: 12, columns: 12)
                    .fill(.foreground.opacity(0.2))
                    .background(.background)
            }
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                    .stroke(.selection, lineWidth: 2)
            }
            .onDrag {
                viewModel.handleDrag()
            }
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview(viewModel: Preview.ViewModel(nsImage: QRCode().nsImage))
            .padding()
    }
}

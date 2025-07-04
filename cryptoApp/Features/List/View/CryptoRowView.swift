//
//  CryptoRowView.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: Crypto

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(crypto.symbol.rawValue)
                    .font(.headline)
                Text(crypto.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: crypto.changeIconName)
                    .foregroundColor(crypto.changeColor)
                Text(crypto.absoluteAndPercentChange)
                    .foregroundColor(crypto.changeColor)
                    .font(.subheadline.bold())
            }
        }
        .padding(.vertical, 8)
    }
}

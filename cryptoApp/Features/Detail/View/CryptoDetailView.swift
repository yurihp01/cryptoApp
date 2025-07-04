//
//  CryptoDetailView.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

struct CryptoDetailView: View {
    @StateObject var viewModel: CryptoDetailViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.headline)
                    Spacer()
                }

            case .failure(let error):
                ErrorView(viewModel: viewModel, error: error)
            case .success(let crypto):
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("\(crypto.symbol.displayName) - \(crypto.symbol.rawValue)")
                            .font(.title)
                            .bold()

                        Text(crypto.formattedPrice)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: crypto.changeIconName)
                            .foregroundColor(crypto.changeColor)
                            .font(.title2)

                        Text(crypto.absoluteAndPercentChange)
                            .foregroundColor(crypto.changeColor)
                            .font(.title3)
                            .bold()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            }
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: viewModel.state)
    }
}

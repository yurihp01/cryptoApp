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
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("\(viewModel.crypto.symbol.displayName) - \(viewModel.crypto.symbol)")
                    .font(.title3)
                
                Text(viewModel.crypto.formattedPrice)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 8) {
                Image(systemName: viewModel.crypto.changeIconName)
                    .foregroundColor(viewModel.crypto.changeColor)
                
                Text(viewModel.crypto.absoluteAndPercentChange)
                    .foregroundColor(viewModel.crypto.changeColor)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

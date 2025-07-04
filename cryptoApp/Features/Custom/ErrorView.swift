//
//  ErrorView.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import SwiftUI

struct ErrorView: View {
    let viewModel: CryptoListViewModel
    let error: Error
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Failed to load")
                .font(.title3)
                .bold()

            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                viewModel.retry()
            }) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            Spacer()
        }
    }
}


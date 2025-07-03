//
//  CryptoDetailViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation

class CryptoDetailViewModel: ObservableObject {
    @Published var viewState: ViewState<Crypto> = .loading
    private let ticker: Crypto
    
    init(ticker: Crypto) {
        self.ticker = ticker
    }
}

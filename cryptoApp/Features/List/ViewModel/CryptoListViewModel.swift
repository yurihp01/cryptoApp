//
//  CryptoListViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation

final class CryptoListViewModel: ObservableObject {
    @Published var viewState: ViewState<[Crypto]> = .loading
    
    private let dependencies: AppDependencies
    private var cancellables = Set<AnyCancellable>()
    private var tickerMap: [String: Crypto] = [:]
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        fetchCryptoData()
        dependencies.
    
    
    



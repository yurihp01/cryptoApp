//
//  ViewState.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

enum ViewState<T> {
    case loading
    case success(T)
    case failure(CryptoError)
}

extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.success(let l), .success(let r)):
            return l == r
        case (.failure(let l), .failure(let r)):
            return l.localizedDescription == r.localizedDescription
        default:
            return false
        }
    }
}

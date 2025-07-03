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

//
//  BinanceStreamWrapper.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

// MARK: - Wrapper
struct BinanceStreamWrapper: Decodable {
    let stream: String
    let data: Crypto
}

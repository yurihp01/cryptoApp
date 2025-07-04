//
//  Crypto.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

// MARK: - Crypto Model
struct Crypto: Decodable, Hashable {
    let symbol: Symbols
    let price: String
    let percentChange: String
    let absoluteChange: String
    
    var priceValue: Double? {
        Double(price)
    }
    
    var absoluteChangeValue: Double? {
        Double(absoluteChange)
    }
    
    var percentChangeValue: Double? {
        Double(percentChange.replacingOccurrences(of: "%", with: ""))
    }
    
    var absoluteAndPercentChange: String {
        guard let abs = absoluteChangeValue, let perc = percentChangeValue else { return "-" }
        return String(format: "%.3f (%.2f%%)", abs, perc)
    }
    
    var changeColor: Color {
        percentChange.hasPrefix("-") ? .red : .green
    }
    
    var changeIconName: String {
        percentChange.hasPrefix("-") ? "arrow.down.right" : "arrow.up.right"
    }
    
    var formattedPrice: String {
        if let price = priceValue {
            return String(format: "$%.2f", price)
        }
        return price
    }
}

// MARK: - CodingKeys
extension Crypto {
    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price = "c"
        case percentChange = "P"
        case absoluteChange = "p"
    }
}

extension Crypto {
    static var mockCrypto: Crypto {
        Crypto(
            symbol: .btcusdt,
            price: "35000",
            percentChange: "2.5",
            absoluteChange: "100000"
        )
    }
}

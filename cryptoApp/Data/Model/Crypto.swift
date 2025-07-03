//
//  Crypto.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation

struct Crypto: Decodable, Hashable {
    let symbol: String
    let price: String
    let percentChange: String
    let absoluteChange: String

    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price = "c"
        case percentChange = "P"
        case absoluteChange = "p"
    }
}

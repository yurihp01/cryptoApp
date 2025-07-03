//
//  CryptoError.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation

enum CryptoError: Error, LocalizedError, Equatable {
    static func == (lhs: CryptoError, rhs: CryptoError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
    
    case invalidURL
    case connectionFailed(Error)
    case disconnected
    case decodingFailed(Error)
    case unknown
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .connectionFailed(let error):
            return "Connection failed: \(error.localizedDescription)"
        case .disconnected:
            return "Connection lost."
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        case .custom(let message):
            return message
        }
    }
}

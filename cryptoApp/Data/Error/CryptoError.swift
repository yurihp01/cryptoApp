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
    
    case connectionFailed(Error)
    case decodingFailed(Error)
    case disconnected(code: UInt16, reason: String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .connectionFailed(let err):
            return "Connection failed: \(err.localizedDescription)"
        case .decodingFailed(let err):
            return "Decoding failed: \(err.localizedDescription)"
        case .disconnected(let code, let reason):
            return "Disconnected (\(code)): \(reason)"
        case .unknown:
            return "Unknown error occurred."
        }
    }
}

import Foundation
import Combine

// MARK: - Protocol
protocol CryptoWebSocketServiceProtocol {
    func getTickers() -> AnyPublisher<[Crypto], CryptoError>
}

// MARK: - CryptoWebSocketService
final class CryptoWebSocketService: CryptoWebSocketServiceProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL
    private let session: URLSession
    private let symbols: [String]
    private let subject = PassthroughSubject<[Crypto], CryptoError>()
    private var isConnected = false
    private var tickers: [String: Crypto] = [:]

    init(symbols: [String], session: URLSession = .shared) {
        self.symbols = symbols
        let symbolString = symbols.map { $0.lowercased() + "@ticker" }.joined(separator: "/")
        self.url = URL(string: "wss://stream.binance.com:9443/ws/\(symbolString)")!
        self.session = session
    }

    func getTickers() -> AnyPublisher<[Crypto], CryptoError> {
        connect()
        return subject.eraseToAnyPublisher()
    }

    private func connect() {
        guard !isConnected else { return }
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        receive()
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self, self.isConnected else { return }
            switch result {
            case .success(let message):
                if case .string(let text) = message,
                   let data = text.data(using: .utf8),
                   let ticker = try? JSONDecoder().decode(Crypto.self, from: data) {
                    self.tickers[ticker.symbol] = ticker
                    self.subject.send(Array(self.tickers.values))
                }
                self.receive()
            case .failure:
                self.reconnectWithDelay()
            }
        }
    }

    private func reconnectWithDelay() {
        isConnected = false
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.connect()
        }
    }
}

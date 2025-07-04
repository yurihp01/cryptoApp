import Foundation
import Combine

// MARK: - Protocol
protocol CryptoWebSocketServiceProtocol {
    var cryptosPublisher: AnyPublisher<[Crypto], Never> { get }
    var errorPublisher: AnyPublisher<CryptoError, Never> { get }
    func connect()
}

// MARK: - Service
final class CryptoWebSocketService: CryptoWebSocketServiceProtocol {
    private let cryptosSubject = CurrentValueSubject<[Crypto], Never>([])
    private let errorSubject = PassthroughSubject<CryptoError, Never>()
    private let symbols: [String]
    private let session: URLSession
    
    private var task: URLSessionWebSocketTask?
    private var isConnected = false
    private var cryptos: [String: Crypto] = [:]
    
    var cryptosPublisher: AnyPublisher<[Crypto], Never> {
        cryptosSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<CryptoError, Never> {
        errorSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    init(symbols: [String], session: URLSession = .shared) {
        self.symbols = symbols
        self.session = session
    }

    func connect() {
        guard !isConnected else { return }

        let stream = symbols.map { "\($0.lowercased())@ticker" }.joined(separator: "/")
        guard let url = URL(string: "wss://stream.binance.com:9443/stream?streams=\(stream)") else { return }

        task = session.webSocketTask(with: url)
        task?.resume()
        isConnected = true
        receive()
    }
}

private extension CryptoWebSocketService {
    func receive() {
        task?.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    handleMessage(text)
                }
                receive()

            case .failure(let error):
                isConnected = false
                errorSubject.send(.connectionFailed(error))
                reconnectWithDelay()
            }
        }
    }

    func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let wrapper = try? JSONDecoder().decode(BinanceStreamWrapper.self, from: data) else {
            errorSubject.send(.decodingFailed(NSError(domain: "Decode", code: 0)))
            return
        }

        cryptos[wrapper.data.symbol.rawValue] = wrapper.data
        cryptosSubject.send(Array(cryptos.values))
    }

    func reconnectWithDelay() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.connect()
        }
    }
}

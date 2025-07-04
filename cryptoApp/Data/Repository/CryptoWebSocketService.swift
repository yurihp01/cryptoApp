import Foundation
import Combine

// MARK: - Protocol
protocol CryptoWebSocketServiceProtocol {
    func getCryptos() -> AnyPublisher<Result<[Crypto], CryptoError>, Never>
}

// MARK: - Service
final class CryptoWebSocketService: CryptoWebSocketServiceProtocol {
    private let symbols: [String]
    private let session: URLSession
    private let subject = CurrentValueSubject<Result<[Crypto], CryptoError>, Never>(.success([]))
    private var task: URLSessionWebSocketTask?
    private var isConnected = false
    private var cryptos: [String: Crypto] = [:]
    
    init(symbols: [String], session: URLSession = .shared) {
        self.symbols = symbols
        self.session = session
        
        connect()
    }
    
    func getCryptos() -> AnyPublisher<Result<[Crypto], CryptoError>, Never> {
        subject.eraseToAnyPublisher()
    }
}

// MARK: - Private methods
private extension CryptoWebSocketService {
    func connect() {
        let stream = symbols.map { "\($0.lowercased())@ticker" }.joined(separator: "/")
        
        guard let url = URL(string: "wss://stream.binance.com:9443/stream?streams=\(stream)"),
              !isConnected else { return }
        
        task = session.webSocketTask(with: url)
        task?.resume()
        isConnected = true
        receive()
    }
    
    func receive() {
        task?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    self.handleMessage(text)
                }
                self.receive()
                
            case .failure(let error):
                self.subject.send(.failure(.connectionFailed(error)))
                self.reconnectWithDelay()
            }
        }
    }
    
    func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else {
            subject.send(.failure(.decodingFailed(NSError(domain: "Invalid UTF-8", code: 0))))
            return
        }
        
        do {
            let wrapper = try JSONDecoder().decode(BinanceStreamWrapper.self, from: data)
            cryptos[wrapper.data.symbol.rawValue] = wrapper.data
            subject.send(.success(Array(cryptos.values)))
        } catch {
            subject.send(.failure(.decodingFailed(error)))
        }
    }
    
    func reconnectWithDelay() {
        isConnected = false
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.connect()
        }
    }
}

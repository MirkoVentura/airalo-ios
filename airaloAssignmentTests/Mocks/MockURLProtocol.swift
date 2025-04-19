import Foundation

final class MockURLProtocol: URLProtocol {
    private static var handlers: [String: (URLRequest) throws -> (HTTPURLResponse, Data)] = [:]
    private static let lock = NSLock()

    static func setHandler(for sessionID: String, handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data)) {
        lock.lock()
        handlers[sessionID] = handler
        lock.unlock()
    }

    static func clearHandler(for sessionID: String) {
        lock.lock()
        handlers.removeValue(forKey: sessionID)
        lock.unlock()
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard
            let sessionID = request.value(forHTTPHeaderField: "X-Session-ID"),
            let handler = Self.handlers[sessionID]
        else {
            fatalError("No mock handler set for session ID")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

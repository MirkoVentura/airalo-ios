import Foundation
import airaloAssignment
import Testing

// MARK: - Helper

func createMockSession(handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data)) -> (URLSession, String) {
    let sessionID = UUID().uuidString
    MockURLProtocol.setHandler(for: sessionID, handler: handler)

    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    config.httpAdditionalHeaders = ["X-Session-ID": sessionID]

    let session = URLSession(configuration: config)
    return (session, sessionID)
}

// MARK: - CountryServiceTests

@Suite("CountryServiceTests")
struct CountryServiceTests {

    @Test("Should decode countries successfully")
    func testFetchCountries_Success() async throws {
        let (session, sessionID) = createMockSession { request in
            let mockJSON = """
            [
                {
                    "id": 2,
                    "slug": "afghanistan",
                    "title": "Afghanistan",
                    "image": {
                        "width": 132,
                        "height": 99,
                        "url": "https://cdn.airalo.com/images/sample.png"
                    },
                    "package_count": 4
                }
            ]
            """.data(using: .utf8)!

            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockJSON)
        }

        let service = CountryService(session: session)
        let countries = try await service.fetchCountries()

        #expect(countries.count == 1)
        #expect(countries.first?.title == "Afghanistan")

        MockURLProtocol.clearHandler(for: sessionID)
    }

    @Test("Should throw for HTTP error status code")
    func testFetchCountries_HTTPError() async throws {
        let (session, sessionID) = createMockSession { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }

        let service = CountryService(session: session)

        do {
            _ = try await service.fetchCountries()
            #expect(Bool(false), "Expected URLError.badServerResponse to be thrown")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .badServerResponse)
        }

        MockURLProtocol.clearHandler(for: sessionID)
    }

    @Test("Should throw for simulated network error")
    func testFetchCountries_NetworkError() async throws {
        let (session, sessionID) = createMockSession { _ in
            throw URLError(.timedOut)
        }

        let service = CountryService(session: session)

        do {
            _ = try await service.fetchCountries()
            #expect(Bool(false), "Expected URLError.timedOut to be thrown")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .timedOut)
        }

        MockURLProtocol.clearHandler(for: sessionID)
    }
}

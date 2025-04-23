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
    
    @Test("Should decode country detail successfully")
    func testFetchCountryDetail_Success() async throws {
        let (session, sessionID) = createMockSession { request in
            // Verifica l'URL dinamico
            #expect(request.url?.absoluteString.contains("united-arab-emirates") == true)

            let mockJSON = """
            {
                "id": 99,
                "slug": "united-arab-emirates",
                "title": "United Arab Emirates",
                "image": {
                    "width": 200,
                    "height": 150,
                    "url": "https://cdn.airalo.com/images/uae.png"
                },
                "package_count": 2,
                "packages": [
                    {
                        "id": 1,
                        "name": "United Arab Emirates 1GB",
                        "title": "1 GB - 7 Days",
                        "data": "1GB",
                        "validity": "7 Days",
                        "slug": "connect-lah-7days-1gb",
                        "price": 4.99,
                        "amount": 12,
                        "day":3,
                        "operator": {
                            "name": "Burj Mobile",
                            "title": "Burj",
                            "country": "United Arab Emirates",
                            "logo": "https://cdn.airalo.com/operators/burj_logo.png",
                            "gradient_start": "#F17F24",
                            "gradient_end": "#FFDE82",
                            "style": "light",
                            "image": {
                                "width": 200,
                                "height": 150,
                                "url": "https://cdn.airalo.com/images/uae.png"
                            },
                        }
                    }
                ]
            }
            """.data(using: .utf8)!

            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockJSON)
        }

        let service = CountryService(session: session)
        let detail = try await service.fetchCountryDetail("united-arab-emirates")

        #expect(detail.title == "United Arab Emirates")
        #expect(detail.packages.isEmpty == false)
        #expect(detail.packages.first?.id == 1)

        MockURLProtocol.clearHandler(for: sessionID)
    }

    @Test("Should throw for simulated network error in country detail")
    func testFetchCountryDetail_NetworkError() async throws {
        let (session, sessionID) = createMockSession { _ in
            throw URLError(.timedOut)
        }

        let service = CountryService(session: session)

        do {
            _ = try await service.fetchCountryDetail("singapore")
            #expect(Bool(false), "Expected URLError.timedOut to be thrown")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .timedOut)
        }

        MockURLProtocol.clearHandler(for: sessionID)
    }

    @Test("Should throw for HTTP error status code in country detail")
    func testFetchCountryDetail_HTTPError() async throws {
        let (session, sessionID) = createMockSession { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }

        let service = CountryService(session: session)

        do {
            _ = try await service.fetchCountryDetail("nonexistent")
            #expect(Bool(false), "Expected URLError.badServerResponse to be thrown")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .badServerResponse)
        }

        MockURLProtocol.clearHandler(for: sessionID)
    }

}

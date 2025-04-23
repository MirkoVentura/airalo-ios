//
//  CountryService.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//


import Foundation

public struct CountryService {
    let session: URLSession

    /// The function used to fetch countries. Can be overridden for mocking.
    public var fetchCountries: () async throws -> [Country]
    public var fetchCountryDetail: (_ slug: String) async throws -> CountryDetail

    /// Initializes the service with a custom URLSession.
    public init(session: URLSession) {
        self.session = session

        self.fetchCountries = {
            let url = URL(string: "https://www.airalo.com/api/v2/countries?type=popular")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(
                NSLocale.current.region?.identifier ?? "en",
                forHTTPHeaderField: "Accept-Language"
            )

            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode([Country].self, from: data)
            return decoded
        }
        
        self.fetchCountryDetail = { slug in
            let url = URL(string: "https://www.airalo.com/api/v2/countries/\(slug)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(
                NSLocale.current.region?.identifier ?? "en",
                forHTTPHeaderField: "Accept-Language"
            )

            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode(CountryDetail.self, from: data)
            return decoded
        }
    }


    /// Allows injecting a mock implementation and a custom session.
    init(
        session: URLSession,
        fetchCountries: @escaping () async throws -> [Country],
        fetchCountryDetail: @escaping (String) async throws -> CountryDetail
    ) {
        self.session = session
        self.fetchCountries = fetchCountries
        self.fetchCountryDetail = fetchCountryDetail
    }
}


extension CountryService {
    
    /// The real service using the shared URLSession.
    static var live: CountryService {
        CountryService(session: .shared)
    }
    
    /// A mocked service returning sample countries.
    static var mock: CountryService {
        CountryService(fetcher:  {
            return [
                Country(
                    id: 1,
                    slug: "italy",
                    title: "Italy",
                    image: AiraloImage(
                        width: 100,
                        height: 75,
                        url: "https://picsum.photos/200"
                    ),
                    packageCount: 3
                ),
                Country(
                    id: 2,
                    slug: "japan",
                    title: "Japan",
                    image: AiraloImage(
                        width: 100,
                        height: 75,
                        url: "https://picsum.photos/200"
                    ),
                    packageCount: 5
                )
            ]
        }, fetcherDetail: { _ in
            CountryDetail(
                id: 1,
                slug: "italy",
                title: "Italia",
                packages: [
                    .init(
                        id: 1,
                        slug: "tim",
                        title: "Tim",
                        data: "7 GB",
                        validity: "7 Days",
                        day: 7,
                        amount: 12,
                        price: 15,
                        operatorInfo: .init(
                            name: "Tim",
                            image: .init(width: 300, height: 300, url: ""),
                            gradientStartColor: "#8897ff",
                            gradientEndColor: "#ced9fd",
                            style: .dark
                        )
                    )
                ]
            )
        })
    }
    
    /// A semantic alias for `.mock`, specifically useful in SwiftUI previews.
    static var preview: CountryService {
        .mock
    }
    
    /// Convenience initializer to inject custom async fetching logic (useful for mocking).
    init(
        fetcher: @escaping () async throws -> [Country],
        fetcherDetail: @escaping (String) async throws -> CountryDetail
    ) {
        self = CountryService(session: .shared)
        self.fetchCountries = fetcher
        self.fetchCountryDetail = fetcherDetail
    }
}


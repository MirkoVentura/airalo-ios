//
//  CountryService.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//


import Foundation

public final class CountryService {
    private let session: URLSession
    private let baseURL = "https://www.airalo.com/api/v2/countries"

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(NSLocale.current.region?.identifier ?? "en", forHTTPHeaderField: "Accept-Language")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode([Country].self, from: data)
        return decoded
    }
}

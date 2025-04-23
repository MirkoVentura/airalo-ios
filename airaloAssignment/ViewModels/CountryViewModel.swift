//
//  CountryViewModel.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//


import Foundation

@Observable
final class CountryViewModel {
    private let service: CountryService
    var countries: [Country] = []
    var countryDetail: CountryDetail?
    var isLoading = false
    var errorMessage: String?

    init(service: CountryService = .live) {
        self.service = service
    }

    @MainActor
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await service.fetchCountries()
            countries = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    @MainActor
    func fetchCountryDetail(for slug: String) async {
        countryDetail = nil
        isLoading = true
        errorMessage = nil

        do {
            countryDetail = try await service.fetchCountryDetail(slug)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

}

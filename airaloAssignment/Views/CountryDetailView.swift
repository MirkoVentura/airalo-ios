//
//  CountryDetailView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//


import SwiftUI

struct CountryDetailView: View {
    let slug: String
    @State private var viewModel: CountryViewModel

    init(slug: String, viewModel: CountryViewModel) {
        self.slug = slug
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if let detail = viewModel.countryDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(detail.packages, id: \.id) { pkg in
                            OperatorPackageView(package: pkg, country: detail.title)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .navigationTitle(detail.title)
                .navigationBackButton(color: .init(hex: "#4A4A4A"), text: "")
            }
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.fetchCountryDetail(for: slug)
        }
        .onDisappear{
            viewModel.countryDetail = nil // clean screen on disappear
        }
    }
}

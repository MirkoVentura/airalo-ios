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
    @Environment(\.colorScheme) var colorScheme

    init(slug: String, viewModel: CountryViewModel) {
        self.slug = slug
        self._viewModel = State(initialValue: viewModel)
        if let uiFont = UIFont(name: "IBMPlexSans-SemiBold", size: 27) {
            UINavigationBar.appearance().titleTextAttributes = [
                .font : uiFont
            ]
        }
       
    }

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if let detail = viewModel.countryDetail {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(detail.packages, id: \.id) { pkg in
                            OperatorPackageView(package: pkg, country: detail.title)
                        }
                    }
                    .padding(.horizontal, 20)
                    .navigationTitle(detail.title)
                }
            }
        }
        .navigationBackButton(color: colorScheme == .dark ? .white : .solidGray , text: "")
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.fetchCountryDetail(for: slug)
        }
        .onDisappear{
            viewModel.countryDetail = nil // clean screen on disappear
        }
    }
}

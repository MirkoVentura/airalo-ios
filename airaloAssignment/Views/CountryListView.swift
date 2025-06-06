//
//  CountryListView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//


import SwiftUI

public struct CountryListView: View {
    @State private var viewModel: CountryViewModel
    @Environment(\.colorScheme) var colorScheme

    init(viewModel: CountryViewModel) {
        self.viewModel = viewModel
        if let uiFont = UIFont(name: "IBMPlexSans-SemiBold", size: 27) {
            UINavigationBar.appearance().titleTextAttributes = [
                .font : uiFont
            ]
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular Countries")
                        .font(.ibmPlexSemiBold(size: 19))
                        .kerning(-0.2)
                        .lineSpacing(32)
                        .foregroundColor(colorScheme == .dark ? .white : .solidGray)
                        .padding(.top, 8)
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.countries, id: \.id) { country in
                                NavigationLink(
                                    destination: CountryDetailView(slug: country.slug, viewModel: viewModel)
                                ) {
                                    CountryRowView(country: country)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Hello")
            .task {
                await viewModel.fetchCountries()
            }
        }

    }
}

#Preview {
    CountryListView(viewModel: CountryViewModel(service: .preview))
}

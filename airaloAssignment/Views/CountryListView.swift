//
//  CountryListView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//


import SwiftUI

public struct CountryListView: View {
    @State private var viewModel: CountryViewModel

    init(viewModel: CountryViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "IBMPlexSans-SemiBold", size: 27)!]
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular Countries")
                        .font(.ibmPlexSemiBold(size: 19))
                        .kerning(-0.2)
                        .lineSpacing(32 * 89/100)
                        .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
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

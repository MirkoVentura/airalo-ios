//
//  ContentView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CountryListView(viewModel: .init(service: .live))
    }
}

#Preview {
    ContentView()
}

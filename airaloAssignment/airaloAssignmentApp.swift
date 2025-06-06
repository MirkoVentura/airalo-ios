//
//  airaloAssignmentApp.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//

import SwiftUI

@main
struct airaloAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            CountryListView(
                viewModel: CountryViewModel(
                    service: CommandLine.arguments.contains("-useMockService") ? .mock : .live
                )
            )
        }
    }
}

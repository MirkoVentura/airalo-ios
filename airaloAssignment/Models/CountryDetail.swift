//
//  CountryDetail.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//

import Foundation

public struct CountryDetail: Codable {
    public let id: Int
    public let slug: String
    public let title: String
    public let packages: [Package]
}

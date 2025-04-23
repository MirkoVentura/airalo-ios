//
//  Package.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//

import Foundation

public struct Package: Codable, Identifiable {
    public let id: Int
    public let slug: String
    public let title: String
    public let data: String
    public let validity: String
    public let day: Int
    public let amount: Int
    public let price: Double
    public let operatorInfo: Operator

    enum CodingKeys: String, CodingKey {
        case id, slug, title, data, validity, day, amount, price
        case operatorInfo = "operator"
    }
}

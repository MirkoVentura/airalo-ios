//
//  Country.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 19/04/25.
//

public struct Country: Codable {
    let id: Int
    let slug: String
    public let title: String
    let image: AiraloImage
    let packageCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case title
        case image
        case packageCount = "package_count"
    }
}

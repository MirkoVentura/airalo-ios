//
//  Operator.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//

import Foundation

public struct Operator: Identifiable, Codable {
    public let id: UUID = UUID()
    public let name: String
    let image: AiraloImage
    public let gradientStartColor: String
    public let gradientEndColor: String
    public let style: Style

    public enum Style: String, Codable {
        case light
        case dark

        public var contentColor: String {
            switch self {
            case .light: return "white"
            case .dark: return "black"
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case image
        case gradientStartColor = "gradient_start"
        case gradientEndColor = "gradient_end"
        case style
    }
}

//
//  CountryRowView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 22/04/25.
//

import SwiftUI

struct CountryRowView: View {
    let country: Country
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: country.image.url)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().frame(width: 37, height: 28)
                default:
                    Color.gray.opacity(0.3)
                        .frame(width: 37, height: 28)
                }
            }

            Text(country.title)
                .font(.ibmPlexSemiBold(size: 15))
                .foregroundColor(colorScheme == .dark ? .white : .solidGray)
                .lineSpacing(20)
               
            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(7)
        .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 10)

    }
}

#Preview {
    CountryRowView(country: .init(id: 1, slug: "usa", title: "USA", image: .init(width: 37, height: 28, url: "https://picsum.photos/200"), packageCount: 4)).padding(20)
}

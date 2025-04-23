//
//  OperatorPackageView.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//


import SwiftUI

struct OperatorPackageView: View {
    let package: Package
    let country: String

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main card
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(package.operatorInfo.name)
                        .font(.headline)
                    Text(country)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider().frame(maxWidth: .infinity)

                HStack {
                    Label("Data", image: "IcData")
                    Spacer()
                    Text(package.data)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                
                Divider().frame(maxWidth: .infinity)
                
                HStack {
                    Label("Validity", image: "IcValidity")
                    Spacer()
                    Text("\(package.validity)")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                
                Divider().frame(maxWidth: .infinity)

                Button(action: {}) {
                    Text("US$ \(String(format: "%.2f", package.price)) – BUY NOW")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(height: 44)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: package.operatorInfo.gradientStartColor),
                        Color(hex: package.operatorInfo.gradientEndColor)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)

            // Floating logo that overlaps the card
            AsyncImage(url: URL(string: package.operatorInfo.image.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
            } placeholder: {
                Color.gray.opacity(0.2)
                    .frame(width: 140, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

            }
            .offset(x: -16, y: -10) // shift up by 10 pts to "break" out of the card
        }
    }
}


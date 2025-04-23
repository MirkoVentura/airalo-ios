//
//  NavigationBackButton.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 23/04/25.
//


import Foundation
import SwiftUI

struct NavigationBackButton: ViewModifier {

    @Environment(\.presentationMode) var presentationMode
    var color: Color
    var text: String?

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {  presentationMode.wrappedValue.dismiss() }, label: {
                    HStack(spacing: 2) {
                        Image("backward")
                            .foregroundColor(color)

                        if let text = text {
                            Text(text)
                                .foregroundColor(color)
                        }
                    }
                })
            )
    }
}

extension View {
    func navigationBackButton(color: Color, text: String? = nil) -> some View {
        modifier(NavigationBackButton(color: color, text: text))
    }
}

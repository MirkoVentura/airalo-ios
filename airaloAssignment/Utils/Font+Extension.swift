//
//  Font+Extension.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 22/04/25.
//

import SwiftUICore

extension Font {
    static func ibmPlexMedium(size: CGFloat) -> Font {
           .custom("IBMPlexSans-Medium", size: size)
       }

       static func ibmPlexSemiBold(size: CGFloat) -> Font {
           .custom("IBMPlexSans-SemiBold", size: size)
       }
}

//
//  Transition+Extension.swift
//  BreathingAnimation
//
//  Created by Alexandru Turcanu on 19/03/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var blurFade: AnyTransition {
        get {
            AnyTransition.modifier(
                active: BlurFadeModifier(isActive: true),
                identity: BlurFadeModifier(isActive: false)
            )
        }
    }
}

struct BlurFadeModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.5 : 1)
            .blur(radius: isActive ? 8 : 0)
            .opacity(isActive ? 0 : 0.7)
    }
}

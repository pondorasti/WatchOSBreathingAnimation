//
//  ContentView.swift
//  BreathingAnimation
//
//  Created by Alexandru Turcanu on 19/03/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfPetals: Double = 5
    @State private var isMinimized = false
    @State private var animationDuration = petalDuration

    /// Duration of the breathing animation
    @State private var breathDuration = 4.2

    /// Duration of addition/removal animation for petals
    static let petalDuration = 0.5

    /// Duration of the BlurFade transition based on the **breathingAnimation**
    private var fadeDuration: Double {
        return breathDuration * 0.6
    }

    var body: some View {
        List {
            Section {
                // Flower
                ZStack {
                    if !isMinimized { // second lil' hack
                        FlowerView(isMinimized: $isMinimized,
                                   numberOfPetals: $numberOfPetals,
                                   animationDuration: $animationDuration
                        ).transition(
                            AnyTransition.asymmetric(
                                insertion: AnyTransition.opacity.animation(Animation.default.delay(animationDuration)),
                                removal: AnyTransition.blurFade.animation(Animation.easeIn(duration: fadeDuration))
                            )
                            /**
                             General Observation - use real devices for best results
                             Asymmetric Transitions are sometimes buggy, this includes:
                                - animationDuration is not always updated prior to a change
                                - the removal transition is used for an insertion
                             */
                        )
                    }

                    // This FlowerView creates a mask around the Main FlowerView
                    FlowerView(isMinimized: $isMinimized,
                               numberOfPetals: $numberOfPetals,
                               animationDuration: $animationDuration,
                               color: Color(UIColor.black)
                    )

                    // Main FlowerView
                    FlowerView(isMinimized: $isMinimized,
                               numberOfPetals: $numberOfPetals,
                               animationDuration: $animationDuration)
                }

                // align the flower nicely
                .frame(maxWidth: .infinity)
                .padding(.vertical, 64)
            }

            // Number of Petals
            Section(header: Text("Number of Petals: \(Int(numberOfPetals))")) {
                Slider(value: $numberOfPetals, in: 2...10) { onEditingChanged in
                    // detect when interaction with the slider is done and engage snapping to the closest petal
                    if !onEditingChanged {
                        self.numberOfPetals = self.numberOfPetals.rounded()
                    }
                }
            }

            // Breathing Duration
            Section(header: Text("Breathing Duration: \(breathDuration)")) {
                Slider(value: $breathDuration, in: 0...10, step: 0.1)
            }

            // Breath Button
            Section {
                Button(action: {
                    self.animationDuration = self.breathDuration
                    self.isMinimized.toggle()

                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                        self.isMinimized.toggle()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2 * self.animationDuration) {
                        self.animationDuration = ContentView.petalDuration
                    }
                }) {
                    Text("Breath")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.white)
            .listRowBackground(Color(UIColor.systemBlue))
        }

        // making the list look nice :]
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

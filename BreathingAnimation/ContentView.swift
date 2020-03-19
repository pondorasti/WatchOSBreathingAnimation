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
    @State private var animationDuration = 0.5

    /// Duration of the breathing animation
    @State private var breathDuration = 4.2

    /**
     Duration of the insertion/deletion animation for petals

     Since this action is controlled by dragging a slider it might sound redundant to add an animation duration, but the flower also has built in support for snapping to the next petal or the current one, depending on the amount of travel.
     */
    private var petalDuration = 0.5

    private var fadeDuration: Double {
        return breathDuration * 0.6
    }

    var body: some View {
        List {
            Section {
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
                             General Observation
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
                               color: Color.black
                    )

                    // Main FlowerView
                    FlowerView(isMinimized: $isMinimized,
                               numberOfPetals: $numberOfPetals,
                               animationDuration: $animationDuration)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
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
                        self.animationDuration = self.petalDuration
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
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  FlowerView.swift
//  BreathingAnimation
//
//  Created by Alexandru Turcanu on 19/03/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

struct FlowerView: View {
    @Binding var isMinimized: Bool
    @Binding var numberOfPetals: Double

    /// The duration of any animation performed to the flower.
    @Binding var animationDuration: Double

    /// The diameter of each petal.
    var circleDiameter: CGFloat = 80

    /// The amount of scaling applied to the flower when the breathing animation starts.
    var scaleAmount: CGFloat = 0.3

    /// The amount of rotation in degrees when the breathing animation starts.
    var breathingRotationDegrees: Double = -90

    /// The color of each petal. It is reccomended to also include the opacity for an overlap effect.
    var color = Color(UIColor.cyan).opacity(0.6)

    private var currentPetalAngle: Double {
        return 360 / numberOfPetals
    }

    /**
     Calculates the opacity for the petal that is being added/removed.

     This is achieved by calculating the amount of travel in **degrees** that the petal needs to travel in order to be completely added to the flower and comparing it with the *nextAngle*. Afterwards converting this to a 0 to 1 scale.
     */
    private var opacityPercentage: Double {
        let numberOfPetals = self.numberOfPetals.rounded(.down)
        let nextAngle = 360 / (numberOfPetals + 1)
        let currentAbsoluteAngle = 360 / numberOfPetals

        let totalTravel = currentAbsoluteAngle - nextAngle
        let currentProgress = currentPetalAngle - nextAngle
        let percentage = currentProgress / totalTravel

        return 1 - percentage
    }

    var body: some View {
        ZStack() {
            /**
             Intentionally showing an extra petal by using x...y

             This allows for the following actions:
                - Instantly animate opacity change to the extra petal
                - Snap to the next or current petal
             */
            ForEach(0...Int(numberOfPetals), id: \.self) { // first lil' hack
                Circle() // Petal
                    .frame(width: self.circleDiameter, height: self.circleDiameter)
                    .foregroundColor(self.color)

                    // animate opacity only to the petal being added/removed
                    .opacity($0 == Int(self.numberOfPetals) ? self.opacityPercentage : 1)

                    // rotate the petal around it's leading anchor to create the flower
                    .rotationEffect(.degrees(self.currentPetalAngle * Double($0)),
                                    anchor: self.isMinimized ? .center : .leading)
            }
        }
        .offset(x: isMinimized ? 0 : circleDiameter / 2)

        // create a frame around the flower, not mandatory, but nicer
        .frame(width: circleDiameter * 2, height: circleDiameter * 2)

        .rotationEffect(.degrees(isMinimized ? breathingRotationDegrees : 0))
        .scaleEffect(isMinimized ? scaleAmount : 1)

        // Dabbled with a custom asymmetric timingCurve, kinda failed
        //0.85, 0, 0.75, 1
        .animation(Animation.timingCurve(isMinimized ? 0.85 : 0.5,
                                         0,
                                         isMinimized ? 0.75 : 0.5,
                                         1, duration: animationDuration))

            
//        .animation(.easeInOut(duration: animationDuration))

        //The purpose of the code bellow is to align the orientation to perfectly match Apple's implementation
        .rotationEffect(.degrees(-60))
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct FlowerView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerView(isMinimized: .constant(false),
                   numberOfPetals: .constant(5),
                   animationDuration: .constant(4.2))
    }
}


//Developer's _personal_ Notes

/**
 ToDo:

 [x] - get the right amount of rotation 90? (sometimes i feel that it's smaller but whatev)
 [x] - blur effect
 [x] - animation timing curve, settled with the default easeInOut, since it's very likely to have the exact timing curve as apple's implementation
 [x] - snapping effect
 [x] - opacity transition
*/



// petalAngle = 360 / numberOfPetals
// actualPetalAngle = 360 / numberOfPetals.rounded
// actualPetalAngle | petalAngle
// Desired alpha 0.55


// 45 <--> 41

//       angle decrease
//       petal addition
//    |------------------>
// |----------------------|


// isAnimating/isBreathing - keep track of breathing animation
// isMinimized - breathing animation state

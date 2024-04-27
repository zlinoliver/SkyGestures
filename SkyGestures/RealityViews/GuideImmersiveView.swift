//
//  GuideImmersiveView.swift
//  SkyGestures
//
//  Created by zlinoliver on 2024/4/27.
//
//

import SwiftUI
import RealityKit
import HandVector

struct GuideImmersiveView: View {
    @Environment(ViewModel.self) private var model
    @State private var subscriptions = [EventSubscription]()
    var body: some View {
        RealityView { content in
            
            let entity = Entity()
            entity.name = "SkyGesture"
            model.rootEntity = entity
            content.add(entity)
            
            // Load all hand gesture parameters into the dictionary.
            model.handEmojiDict = HandEmojiParameter.generateParametersDict(fileName: "HandEmojiTotalJson")!
            
            // Initialize a variable to record the time when the last command was sent.
            var lastCommandTime: Date? = nil

            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                // Check if it has been 2 seconds since the last command was sent.
                if let lastTime = lastCommandTime, Date().timeIntervalSince(lastTime) < 2 {
                    return
                }
        
                //Hand Gesture Commands: Takeoff:👌, Land:✊, Fly Upward: 👆, Fly Downward: 🤏, Fly Forward: 🤙, Fly Backward: 🤚, Fly Leftward: 👈, Fly Rightward: 👍, Stop: 🫰, Rotate Leftward: 🤘, Rotate Rightward: 🤟, Flip: ✌️
                
                // Recognize the gesture and perform the corresponding action.
                if let okGesture = model.handEmojiDict["👌"]?.convertToHandVectorMatcher(),
                   let pointUpGesture = model.handEmojiDict["👆"]?.convertToHandVectorMatcher(),
                   let fistGesture = model.handEmojiDict["✊"]?.convertToHandVectorMatcher(),
                   let openHandGesture = model.handEmojiDict["✋"]?.convertToHandVectorMatcher(),
                   let pinchHandGesture = model.handEmojiDict["🤏"]?.convertToHandVectorMatcher(),
                   let callMeHandGesture = model.handEmojiDict["🤙"]?.convertToHandVectorMatcher(),
                   let pointLeftHandGesture = model.handEmojiDict["👈"]?.convertToHandVectorMatcher(),
                   let thumbsUpHandGesture = model.handEmojiDict["👍"]?.convertToHandVectorMatcher(),
                   let fingerHeartHandGesture = model.handEmojiDict["🫰"]?.convertToHandVectorMatcher(),
                   let loveYouHandGesture = model.handEmojiDict["🤟"]?.convertToHandVectorMatcher(),
                   let signOfHornsHandGesture = model.handEmojiDict["🤘"]?.convertToHandVectorMatcher(),
                   let victoryGesture = model.handEmojiDict["✌️"]?.convertToHandVectorMatcher(){
                   
                    // Check the right hand vector.
                    if let rightHandVector = model.latestHandTracking.rightHandVector {

                        // Calculate the similarity of the right hand to the "👌" gesture.
                        if let rightOKGesture = okGesture.right {
                            let rightOKScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightOKGesture)
//                            print("right hand 👌 score: \(rightOKScore)")

                            if rightOKScore > 0.90 {
                                print("Takeoff")
                                NotificationCenter.default.post(name: .takeoffGesture, object: nil)
                                lastCommandTime = Date() // 更新发送指令的时间
                            }
                        }

                        // Calculate the similarity of the right hand to the "✊" gesture.
                        if let rightFistGesture = fistGesture.right {
                            let rightFistScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightFistGesture)
//                            print("right hand ✊ score: \(rightFistScore)")

                            if rightFistScore > 0.90 {
                                print("Land")
                                NotificationCenter.default.post(name: .landGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "👆" gesture.
                        if let rightUpGesture = pointUpGesture.right {
                            let rightUpScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightUpGesture)
//                            print("right hand 👆 score: \(rightUpScore)")

                            if rightUpScore > 0.90 {
                                print("Fly Upward")
                                NotificationCenter.default.post(name: .flyUpwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "✋" gesture.
                        if let rightOpenHandGesture = openHandGesture.right {
                            let rightOpenHandScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightOpenHandGesture)
//                            print("right hand ✋ score: \(rightOpenHandScore)")

                            if rightOpenHandScore > 0.90 {
                                print("Fly backward")
                                NotificationCenter.default.post(name: .flyBackwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }
                        
                        // Calculate the similarity of the right hand to the "✌️" gesture.
                        if let rightVictoryGesture = victoryGesture.right {
                            let rightVictoryScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightVictoryGesture)
//                            print("right hand ✌️ score: \(rightVictoryScore)")

                            if rightVictoryScore > 0.90 {
                                print("Flip")
                                NotificationCenter.default.post(name: .flipGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }
                        
                        // Calculate the similarity of the right hand to the "🤏" gesture.
                        if let rightPinchGesture = pinchHandGesture.right {
                            let rightPinchScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightPinchGesture)
//                            print("right hand 🤏 score: \(rightPinchScore)")

                            if rightPinchScore > 0.90 {
                                print("Fly Downward")
                                NotificationCenter.default.post(name: .flyDownwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "🤙" gesture.
                        if let rightCallMeGesture = callMeHandGesture.right {
                            let rightCallMeScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightCallMeGesture)
//                            print("right hand 🤙 score: \(rightCallMeScore)")

                            if rightCallMeScore > 0.90 {
                                print("Fly Forward")
                                NotificationCenter.default.post(name: .flyForwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "👈" gesture.
                        if let rightPointLeftGesture = pointLeftHandGesture.right {
                            let rightPointLeftScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightPointLeftGesture)
//                            print("right hand 👈 score: \(rightPointLeftScore)")

                            if rightPointLeftScore > 0.95 {
                                print("Fly Leftward")
                                NotificationCenter.default.post(name: .flyLeftwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "👍" gesture.
                        if let rightThumbsUpGesture = thumbsUpHandGesture.right {
                            let rightThumbsUpScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightThumbsUpGesture)
//                            print("right hand 👍 score: \(rightThumbsUpScore)")

                            if rightThumbsUpScore > 0.90 {
                                print("Fly Rightward")
                                NotificationCenter.default.post(name: .flyRightwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "🫰" gesture.
                        if let rightFingerHeartGesture = fingerHeartHandGesture.right {
                            let rightFingerHeartScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightFingerHeartGesture)
//                            print("right hand 🫰 score: \(rightFingerHeartScore)")

                            if rightFingerHeartScore > 0.95 {
                                print("Stop")
                                NotificationCenter.default.post(name: .stopGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "🤟" gesture.
                        if let rightLoveYouGesture = loveYouHandGesture.right {
                            let rightLoveYouScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightLoveYouGesture)
//                            print("right hand 🤟 score: \(rightLoveYouScore)")

                            if rightLoveYouScore > 0.90 {
                                print("Rotate Rightward")
                                NotificationCenter.default.post(name: .rotateRightwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // Calculate the similarity of the right hand to the "🤘" gesture.
                        if let rightSignOfHornsGesture = signOfHornsHandGesture.right {
                            let rightSignOfHornsScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightSignOfHornsGesture)
//                            print("right hand 🤘 score: \(rightSignOfHornsScore)")

                            if rightSignOfHornsScore > 0.90 {
                                print("Rotate Leftward")
                                NotificationCenter.default.post(name: .rotateLeftwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }
                        
                    } else {
                        
                    }
                } else {

                }
            }))
            
            model.latestHandTracking.isSkeletonVisible = true
            
        } update: { content in
            
        }
        
        .task {
            await model.startHandTracking()
        }
        .task {
            await model.publishHandTrackingUpdates()
        }
        .task {
            await model.monitorSessionEvents()
        }
#if targetEnvironment(simulator)
        .task {
            await model.publishSimHandTrackingUpdates()
        }
#endif
    }
}

//#Preview {
//    GuideImmersiveView()
//}

//
//  GuideImmersiveView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/8.
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
            entity.name = "GameRoot"
            model.rootEntity = entity
            content.add(entity)
            
            // 加载所有手势的参数到字典中
            model.handEmojiDict = HandEmojiParameter.generateParametersDict(fileName: "HandEmojiTotalJson")!
            // 初始化一个变量来记录上次指令发送的时间
            var lastCommandTime: Date? = nil

            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                // 检查距离上次发送指令是否已经过去2秒
                if let lastTime = lastCommandTime, Date().timeIntervalSince(lastTime) < 2 {
                    return
                }
                
                // 手势识别并执行相应操作
                if let okGesture = model.handEmojiDict["👌"]?.convertToHandVectorMatcher(),
                   let upGesture = model.handEmojiDict["👆"]?.convertToHandVectorMatcher(),
                   let fistGesture = model.handEmojiDict["✊"]?.convertToHandVectorMatcher(),
                   let openHandGesture = model.handEmojiDict["✋"]?.convertToHandVectorMatcher(),
                   let peaceGesture = model.handEmojiDict["✌️"]?.convertToHandVectorMatcher(){
                   
                    // 检查左手向量
                    if let leftHandVector = model.latestHandTracking.leftHandVector {
                        
                        // 计算左手对👌手势的相似度
                        if let leftOKGesture = okGesture.left {
                            let leftOKScore = leftHandVector.similarity(of: HandVectorMatcher.allFingers, to: leftOKGesture)
//                            print("Left hand 👌 score: \(leftOKScore)")

                            if leftOKScore > 0.9 {
                                print("Takeoff")
                                NotificationCenter.default.post(name: .takeoffGesture, object: nil)
                                lastCommandTime = Date() // 更新发送指令的时间
                            }
                        }

                        // 计算左手对✊手势的相似度
                        if let leftFistGesture = fistGesture.left {
                            let leftFistScore = leftHandVector.similarity(of: HandVectorMatcher.allFingers, to: leftFistGesture)
//                            print("Left hand ✊ score: \(leftFistScore)")

                            if leftFistScore > 0.9 {
                                print("Land")
                                NotificationCenter.default.post(name: .landGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }

                        // 计算左手对👆手势的相似度
                        if let leftUpGesture = upGesture.left {
                            let leftUpScore = leftHandVector.similarity(of: HandVectorMatcher.allFingers, to: leftUpGesture)
//                            print("Left hand 👆 score: \(leftUpScore)")

                            if leftUpScore > 0.85 {
                                print("Move forward")
                                NotificationCenter.default.post(name: .moveForwardGesture, object: nil)
                                lastCommandTime = Date() // 更新发送指令的时间
                            }
                        }

                        // 计算左手对✋手势的相似度
                        if let leftOpenHandGesture = openHandGesture.left {
                            let leftOpenHandScore = leftHandVector.similarity(of: HandVectorMatcher.allFingers, to: leftOpenHandGesture)
//                            print("Left hand ✋ score: \(leftOpenHandScore)")

                            if leftOpenHandScore > 0.85 {
                                print("Move backward")
                                NotificationCenter.default.post(name: .moveBackwardGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }
                        
                        // 计算左手对✌️手势的相似度
                        if let leftPeaceGesture = peaceGesture.left {
                            let leftPeaceScore = leftHandVector.similarity(of: HandVectorMatcher.allFingers, to: leftPeaceGesture)
//                            print("Left hand ✌️ score: \(leftPeaceScore)")

                            if leftPeaceScore > 0.83 {
                                print("Flip")
                                NotificationCenter.default.post(name: .flipGesture, object: nil)
                                lastCommandTime = Date()
                            }
                        }
                        
                    } else {
                        
                    }
                } else {

                }
            }))
            
            model.latestHandTracking.isSkeletonVisible = true

//
//            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
//                    // 检查距离上次发送指令是否已经过去3秒
//                    if let lastTime = lastCommandTime, Date().timeIntervalSince(lastTime) < 3 {
//                        print("Skipping this check, within cooldown period.")
//                        return
//                    }
//                    
//                    // 手势识别并执行相应操作
//                    if let okGesture = model.handEmojiDict["👌"]?.convertToHandVectorMatcher(),
//                       let upGesture = model.handEmojiDict["👆"]?.convertToHandVectorMatcher(),
//                       let fistGesture = model.handEmojiDict["✊"]?.convertToHandVectorMatcher(),
//                       let openHandGesture = model.handEmojiDict["✋"]?.convertToHandVectorMatcher() {
//
//                        // 检查右手向量
//                        if let rightHandVector = model.latestHandTracking.rightHandVector {
//                            print("Checking right hand gestures...")
//                            print("Right hand vector is available.")
//                            
//                            // 计算右手对👌手势的相似度
//                            if let rightOKGesture = okGesture.right {
//                                let rightOKScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightOKGesture)
//                                print("Right hand 👌 score: \(rightOKScore)")
//                                if rightOKScore > 0.8 {
//                                    print("Takeoff")
//                                    lastCommandTime = Date() // 更新发送指令的时间
//                                }
//                            }
//
//                            // 计算右手对✊手势的相似度
//                            if let rightFistGesture = fistGesture.right {
//                                let rightFistScore = rightHandVector.similarity(of: HandVectorMatcher.allFingers, to: rightFistGesture)
//                                print("Right hand ✊ score: \(rightFistScore)")
//                                if rightFistScore > 0.8 {
//                                    print("Takeoff")
//                                    lastCommandTime = Date()
//                                }
//                            }
//                        } else {
//                            print("No right hand vector available.")
//                        }
//                    } else {
//                        print("Failed to load hand gestures.")
//                    }
//                }))
            
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
//
//#Preview {
//    GuideImmersiveView()
//}

//
//  SwiftUIView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/11.
//


import SwiftUI

struct Guide: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @StateObject private var droneManager = TelloDroneManager()
    
    var body: some View {
        @Bindable var model = model
        VStack {
            // 标题和副标题
            VStack {
                Text("SkyGestures")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Control Tello drone using your hand gesture!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                    .padding(.vertical, 30)
            }
            .padding()

            Toggle("Start to use Hand Gestures", isOn: $model.showGuideImmersiveSpace)
                .toggleStyle(ButtonToggleStyle())
                .padding(.vertical, 30)
                .font(.system(size: 16, weight: .bold))
            
            // 连接状态和按钮
            VStack {
                Text(droneManager.isConnected ? "Drone Connected" : "Drone Not Connected")
                    .foregroundColor(droneManager.isConnected ? .green : .red)
                    .font(.headline)
                    .padding()
                Button(action: {
                    droneManager.connectToDrone()
                }) {
                    Text("Connect")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .cornerRadius(10)
                }
                .disabled(droneManager.isConnected)
                
//                // Take off button
//                Button("Takeoff") {
//                    droneManager.pressTakeoff()
//                }
//                
//                // Land button
//                Button("Land") {
//                    droneManager.pressLand()
//                }
//                
//                // Move forward button
//                Button("Move Forward") {
//                    droneManager.pressMoveForward(distance: 20)
//                }
//
//                // Move backward button
//                Button("Move Backward") {
//                    droneManager.pressMoveBackward(distance: 20)
//                }
                                        
            }
            .onReceive(NotificationCenter.default.publisher(for: .takeoffGesture)) { _ in
                print("Takeoff gesture detected in Guide View")
                droneManager.pressTakeoff()
            }
            .onReceive(NotificationCenter.default.publisher(for: .landGesture)) { _ in
                print("Land gesture detected in Guide View")
                droneManager.pressLand()
            }
            .onReceive(NotificationCenter.default.publisher(for: .moveForwardGesture)) { _ in
                print("move forward gesture detected in Guide View")
                droneManager.pressMoveForward(distance: 20)
            }
            .onReceive(NotificationCenter.default.publisher(for: .moveBackwardGesture)) { _ in
                print("move backward gesture detected in Guide View")
                droneManager.pressMoveBackward(distance: 20)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flipGesture)) { _ in
                print("flip gesture detected in Guide View")
                //direction (str): Direction to flip, 'l', 'r', 'f', 'b'.
                droneManager.pressFlip(direction: "f")
            }
            
            // 手势指令和分数
            VStack(spacing: 20) {
                Text("Try to use the following hand gestures to control Tello drone")
                    .font(.headline)
                    .padding(.vertical, 50)
                    .multilineTextAlignment(.center)

                HStack(spacing: 50) {
                    GestureCommandView(gesture: NSLocalizedString("Takeoff", comment: "Command to take off"), symbolName: "👌")
                    GestureCommandView(gesture: NSLocalizedString("Land", comment: "Command to land"), symbolName: "✊")
                    GestureCommandView(gesture: NSLocalizedString("Move Forward", comment: "Command to move forward"), symbolName: "👆")
                    GestureCommandView(gesture: NSLocalizedString("Move Backward", comment: "Command to move backward"), symbolName: "✋")
                    GestureCommandView(gesture: NSLocalizedString("Flip", comment: "Command to flip"), symbolName: "✌️")
                }

//                HStack {
//                    ScoreView(label: NSLocalizedString("LeftScore", comment: "Left hand score"), score: model.leftScore)
//                        .padding(.top, 10)
//                    ScoreView(label: NSLocalizedString("RightScore", comment: "Right hand score"), score: model.rightScore)
//                        .padding(.top, 10)
//                }
            }
            .padding()
        }        
        .onChange(of: model.showGuideImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                    model.leftScore = 0
                    model.rightScore = 0
                }
            }
        }
    }
    
}

// 分数视图
struct ScoreView: View {
    let label: String
    let score: Int

    var body: some View {
        Text("\(label): \(score)")
    }
}

// 手势命令视图
struct GestureCommandView: View {
    let gesture: String
    let symbolName: String

    var body: some View {
        VStack {
            Text(symbolName)
                .font(.largeTitle)
            Text(gesture)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    Guide()
        .environment(ViewModel())
        .glassBackgroundEffect(
            in: RoundedRectangle(
                cornerRadius: 32,
                style: .continuous
            )
        )
}

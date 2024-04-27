//
//  Guide.swift
//  SkyGestures
//
//  Created by zlinoliver on 2024/4/27.
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
            // Title and Subtitle
            VStack {
                Text("SkyGestures")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Control Tello drone using your hand gesture!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                    .padding(.vertical, 20)
            }
            .padding()

            Toggle("Start to use Hand Gestures", isOn: $model.showGuideImmersiveSpace)
                .toggleStyle(ButtonToggleStyle())
                .padding(.vertical, 30)
                .font(.system(size: 16, weight: .bold))
            
            // Drone Connection Status and Button
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
                                        
            }
            .onReceive(NotificationCenter.default.publisher(for: .takeoffGesture)) { _ in
                print("Takeoff gesture detected in Guide View")
                droneManager.takeoff()
                droneManager.setSpeed(kph: 2)
            }
            .onReceive(NotificationCenter.default.publisher(for: .landGesture)) { _ in
                print("Land gesture detected in Guide View")
                droneManager.land()
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyForwardGesture)) { _ in
                print("fly forward gesture detected in Guide View")
                droneManager.flyForward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyBackwardGesture)) { _ in
                print("fly backward gesture detected in Guide View")
                droneManager.flyBackward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flipGesture)) { _ in
                print("flip gesture detected in Guide View")
                //direction (str): Direction to flip, 'l', 'r', 'f', 'b'.
                droneManager.flip(direction: "f")
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyUpwardGesture)) { _ in
                print("fly downward gesture detected in Guide View")
                droneManager.flyUpward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyDownwardGesture)) { _ in
                print("fly downward gesture detected in Guide View")
                droneManager.flyDownward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyLeftwardGesture)) { _ in
                print("fly leftward gesture detected in Guide View")
                droneManager.flyLeftward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .flyRightwardGesture)) { _ in
                print("fly leftward gesture detected in Guide View")
                droneManager.flyRightward(distance: 35)
            }
            .onReceive(NotificationCenter.default.publisher(for: .stopGesture)) { _ in
                print("stop gesture detected in Guide View")
                droneManager.stop()
            }
            .onReceive(NotificationCenter.default.publisher(for: .rotateRightwardGesture)) { _ in
                print("rotate rightward gesture detected in Guide View")
                droneManager.rotateRightward(degrees: 15)
            }
            .onReceive(NotificationCenter.default.publisher(for: .rotateLeftwardGesture)) { _ in
                print("rotate leftward gesture detected in Guide View")
                droneManager.rotateLeftward(degrees: 15)
            }
            
            // Hand Gesture Commands
            VStack(spacing: 20) {
                Text("Try to use the following hand gestures to control Tello drone")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)

                //Takeoff:👌, Land:✊, Fly Upward: 👆, Fly Downward: 🤏, Fly Forward: 🤙, Fly Backward: 🤚, Fly Leftward: 👈, Fly Rightward: 👍, Stop: 🫰, Rotate Leftward: 🤘, Rotate Rightward: 🤟, Flip: ✌️

                VStack {
                    HStack(spacing: 45) {
                        GestureCommandView(gesture: NSLocalizedString("Takeoff", comment: "Command to take off"), symbolName: "👌")
                        GestureCommandView(gesture: NSLocalizedString("Land", comment: "Command to land"), symbolName: "✊")
                        GestureCommandView(gesture: NSLocalizedString("Fly Forward", comment: "Command to fly forward"), symbolName: "🤙")
                        GestureCommandView(gesture: NSLocalizedString("Fly Backward", comment: "Command to fly backward"), symbolName: "✋")
                        GestureCommandView(gesture: NSLocalizedString("Fly Upward", comment: "Command to fly upward"), symbolName: "👆")
                        GestureCommandView(gesture: NSLocalizedString("Fly Downward", comment: "Command to fly downward"), symbolName: "🤏")
                    }
                    HStack(spacing: 45) {
                        GestureCommandView(gesture: NSLocalizedString("Fly Leftward", comment: "Command to fly leftward"), symbolName: "👈")
                        GestureCommandView(gesture: NSLocalizedString("Fly Rightward", comment: "Command to fly rightward"), symbolName: "👍")
                        GestureCommandView(gesture: NSLocalizedString("Stop", comment: "Command to stop"), symbolName: "🫰")
                        GestureCommandView(gesture: NSLocalizedString("Rotate Leftward", comment: "Command to rotate leftward"), symbolName: "🤘")
                        GestureCommandView(gesture: NSLocalizedString("Rotate Rightward", comment: "Command to rotate rightward"), symbolName: "🤟")
                        GestureCommandView(gesture: NSLocalizedString("Flip", comment: "Command to flip"), symbolName: "✌️")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)

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

// Hand Gesture Command View
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

//#Preview {
//    Guide()
//        .environment(ViewModel())
//        .glassBackgroundEffect(
//            in: RoundedRectangle(
//                cornerRadius: 32,
//                style: .continuous
//            )
//        )
//}

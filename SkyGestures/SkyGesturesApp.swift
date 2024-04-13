//
//  SkyGesturesApp.swift
//  SkyGestures
//
//  Created by zlinoliver on 2024/4/13.
//

import SwiftUI

@main
struct SkyGesturesApp: App {
    @State private var model = ViewModel()
    var body: some Scene {
        WindowGroup {
            Guide()
                .environment(model)
//                .environment(\.locale, .init(identifier: "en"))
        }
        .windowStyle(.automatic)

        ImmersiveSpace(id: "ImmersiveSpace") {
            GuideImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}

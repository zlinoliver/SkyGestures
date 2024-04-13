//
//  NotificationNames.swift
//  HandVectorDemo
//
//  Created by zlinoliver on 2024/4/13.
//

import Foundation

extension Notification.Name {
    static let takeoffGesture = Notification.Name("takeoffGesture")
    static let landGesture = Notification.Name("landGesture")
    static let moveForwardGesture = Notification.Name("moveForwardGesture")
    static let moveBackwardGesture = Notification.Name("moveBackwardGesture")
    static let flipGesture = Notification.Name("flipGesture")
}

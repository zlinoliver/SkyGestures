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
    static let flyForwardGesture = Notification.Name("flyForwardGesture")
    static let flyBackwardGesture = Notification.Name("flyBackwardGesture")
    static let flipGesture = Notification.Name("flipGesture")
    static let flyUpwardGesture = Notification.Name("flyUpwardGesture")
    static let flyDownwardGesture = Notification.Name("flyDownwardGesture")
    static let flyLeftwardGesture = Notification.Name("flyLeftwardGesture")
    static let flyRightwardGesture = Notification.Name("flyRightwardGesture")
    static let stopGesture = Notification.Name("stopGesture")
    static let rotateRightwardGesture = Notification.Name("rotateRightwardGesture")
    static let rotateLeftwardGesture = Notification.Name("rotateLeftwardGesture")
}

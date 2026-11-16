//
//  PLANTS_appApp.swift
//  PLANTS.app
//
//  Created by Raghad on 06/06/1448 AH.
//

import SwiftUI

@main
struct PlantsAppApp: App {

    init() {
        // يفعّل مدير الإشعارات من أول لحظة (عشان تظهر الإشعارات والتطبيق مفتوح)
        _ = NotificationManager.shared
    }

    var body: some Scene {
        WindowGroup {
            MyPlantsView()
        }
    }
}

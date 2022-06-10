//
//  NBodySimulationApp.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/9.
//

import SwiftUI

@main
struct NBodySimulationApp: App {
    @EnvironmentObject var universe: NBodyUniverse
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(NBodyUniverse.emptyUniverse)
        }
    }
}

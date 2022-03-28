//
//  SwiftUI_AnimationsApp.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

@main
struct SwiftUI_AnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            Start()
                .preferredColorScheme(.light)
                .statusBar(hidden: true)
        }
    }
}

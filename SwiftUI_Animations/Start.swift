//
//  Start.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

struct Start: View {
    @State var showMenu: Bool = false
    
    var body: some View {
        VStack(spacing: 48) {
            MainView(showMenu: $showMenu)
            if showMenu {
                MenuView(showMenu: $showMenu, menuType: .artwork)
            }
        }
        .ignoresSafeArea()
    }
}

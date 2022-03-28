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
        ZStack {
            VStack(spacing: 48) {
                ArtworkView(showMenu: $showMenu)
                if showMenu {
                    MenuView(showMenu: $showMenu, menuType: .artwork)
                }
            }
        }
        .ignoresSafeArea()
    }
}

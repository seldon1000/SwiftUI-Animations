//
//  MainView.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

struct MainView: View {
    @State var isPlaying: Bool = false
    
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            Color.pink
                .opacity(isPlaying ? 0.0 : 0.2)
            if isPlaying {
                GameView(grid: Grid(level: level), isPlaying: $isPlaying)
                    .zIndex(100)
            }
        }
        .frame(width: UIScreen.main.bounds.width * (showMenu ? 0.5 : 1.0), height: UIScreen.main.bounds.height * (showMenu ? 0.5 : 1.0))
        .onTapGesture {
            if showMenu {
                withAnimation(.easeInOut) {
                    showMenu = false
                }
            } else {
                withAnimation(.easeInOut) {
                    isPlaying = true
                }
            }
        }
        .onLongPressGesture {
            withAnimation(.easeInOut) {
                showMenu.toggle()
            }
        }
    }
}

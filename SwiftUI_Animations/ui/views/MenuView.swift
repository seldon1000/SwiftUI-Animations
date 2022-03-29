//
//  MenuView.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

enum MenuType {
    case game
    case artwork
}

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var isPlaying: Bool
    
    let menuType: MenuType
    let resetLevel: () -> Void
    
    init(showMenu: Binding<Bool>, isPlaying: Binding<Bool> = .constant(true), menuType: MenuType, resetLevel: @escaping () -> Void = {}) {
        self._showMenu = showMenu
        self._isPlaying = isPlaying
        self.menuType = menuType
        self.resetLevel = resetLevel
    }
    
    var body: some View {
        switch menuType {
        case .game:
            HStack(spacing: 16) {
                CircularMenuButton(label: "arrow.left") {
                    withAnimation(.easeInOut) {
                        isPlaying = false
                        showMenu = false
                    }
                }
                CircularMenuButton(label: "arrow.clockwise", action: resetLevel)
            }
        case .artwork:
            VStack(spacing: 16) {
                MenuButton(label: "Button 1") {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
                MenuButton(label: "Button 2") {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
            }
        }
    }
}

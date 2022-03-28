//
//  GameView.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

struct GameView: View {
    @State var grid: Grid
    @State var showMenu: Bool = false
    @State var win: Bool = false
    @State var scale: Double = 0.0
    
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<grid.rows, id: \.self) { i in
                    HStack(spacing: 0) {
                        ForEach(grid.dots[i]) { dot in
                            DotComponent(win: $win, dot: dot)
                        }
                    }
                }
            }
            .environmentObject(grid)
            .contentShape(Rectangle())
            .scaleEffect(scale)
            .frame(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showMenu = false
                    scale = 1.0
                }
            }
            .onLongPressGesture {
                if !win {
                    withAnimation(.easeInOut) {
                        showMenu = true
                        scale = 0.6
                    }
                }
            }
            .gesture(DragGesture().onEnded { value in
                if !win && !showMenu {
                    if grid.dragGesture(translation: value.translation) {
                        win.toggle()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut) {
                                showMenu = false
                                isPlaying = false
                            }
                        }
                    }
                }
            })
            if showMenu {
                MenuView(showMenu: $showMenu, isPlaying: $isPlaying, menuType: .game) {
                    if !win {
                        grid.resetGrid()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut) {
                                showMenu = false
                                scale = 1.0
                            }
                        }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
        .onAppear {
            withAnimation(.easeInOut) {
                scale = 1.0
            }
        }
        .onChange(of: isPlaying) { newValue in
            if !newValue {
                withAnimation(.easeInOut) {
                    scale = 0.0
                }
            }
        }
    }
}

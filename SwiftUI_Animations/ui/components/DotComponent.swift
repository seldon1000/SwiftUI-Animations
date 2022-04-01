//
//  DotComponent.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

struct DotComponent: View {
    @EnvironmentObject var grid: Grid
    
    @State var isObstacle: Bool = false
    @State var diameter: CGFloat = 64
    
    @Binding var win: Bool
    
    var dot: Dot
    
    var body: some View {
        Circle()
            .fill(Color(isObstacle ? dot.obstacleColor : dot.color))
            .frame(width: diameter, height: diameter)
            .overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))
            .scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))
            .padding(6)
            .onAppear {
                diameter = UIScreen.main.bounds.width / CGFloat(grid.cols) - 17
                isObstacle = dot.isObstacle
            }
            .onChange(of: win) { newValue in
                if dot.isObstacle && newValue {
                    withAnimation(.easeInOut.delay(Double.random(in: 0.5...1.5))) {
                        isObstacle = false
                    }
                }
            }
    }
}

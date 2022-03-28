//
//  Grid.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

class Grid: ObservableObject {
    @Published var currentDot: (Int, Int)
    
    private var dotsToWin: Int
    var dots: [[Dot]]
    
    private let startDot: (Int, Int)
    let rows: Int
    let cols: Int
    
    init(level: Level) {
        currentDot = level.startDot
        
        dotsToWin = level.rows * level.cols - level.obstacles.count - 1
        dots = []
        
        startDot = level.startDot
        rows = level.rows
        cols = level.cols
        
        for i in 0..<rows {
            dots.append([])
            
            for j in 0..<cols {
                dots[i].append(Dot(isObstacle: level.obstacles.contains(where: { k in k == (i, j) }), coordinates: (i, j)))
            }
        }
        
        dots[currentDot.0][currentDot.1].isColored = true
    }
    
    func dragGesture(translation: CGSize) -> Bool {
        var j: Double = 0.3
        
        if translation.width > 90 {
            var i = currentDot.1 + 1
            
            while i < cols && !dots[currentDot.0][i].isObstacle && dotsToWin > 0 {
                if !dots[currentDot.0][i].isColored {
                    dotsToWin -= 1
                }
                
                withAnimation(.easeInOut(duration: j)) {
                    currentDot.1 = i
                    dots[currentDot.0][i].isColored = true
                }
                
                i += 1
                j *= 1.06
            }
        } else if translation.width < -90 {
            var i = currentDot.1 - 1
            
            while i >= 0 && !dots[currentDot.0][i].isObstacle && dotsToWin > 0 {
                if !dots[currentDot.0][i].isColored {
                    dotsToWin -= 1
                }
                
                withAnimation(.easeInOut(duration: j)) {
                    currentDot.1 = i
                    dots[currentDot.0][i].isColored = true
                }
                
                i -= 1
                j *= 1.06
            }
        } else if translation.height < -90 {
            var i = currentDot.0 - 1
            
            while i >= 0 && !dots[i][currentDot.1].isObstacle && dotsToWin > 0 {
                if !dots[i][currentDot.1].isColored {
                    dotsToWin -= 1
                }
                
                withAnimation(.easeInOut(duration: j)) {
                    currentDot.0 = i
                    dots[i][currentDot.1].isColored = true
                }
                
                i -= 1
                j *= 1.1
            }
        } else if translation.height > 90 {
            var i = currentDot.0 + 1
            
            while i < rows && !dots[i][currentDot.1].isObstacle && dotsToWin > 0 {
                if !dots[i][currentDot.1].isColored {
                    dotsToWin -= 1
                }
                
                withAnimation(.easeInOut(duration: j)) {
                    currentDot.0 = i
                    dots[i][currentDot.1].isColored = true
                }
                
                i += 1
                j *= 1.06
            }
        }
        
        return dotsToWin == 0
    }
    
    func resetGrid() {
        dotsToWin = 0
        
        for i in 0..<dots.count {
            for dot in dots[i] {
                if !dot.isObstacle && dot.coordinates != startDot {
                    withAnimation(.easeInOut) {
                        currentDot = startDot
                        dot.isColored = false
                    }
                    
                    dotsToWin += 1
                }
            }
        }
    }
}

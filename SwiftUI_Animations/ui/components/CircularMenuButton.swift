//
//  CircularMenuButton.swift
//  SwiftUI_Animations
//
//  Created by Nicolas Mariniello on 28/03/22.
//

import SwiftUI

struct CircularMenuButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(.white)
                    .frame(width: 56, height: 56)
                Image(systemName: label)
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(.black)
            }
        }
        .shadow(color: .gray.opacity(0.2), radius: 8)
    }
}

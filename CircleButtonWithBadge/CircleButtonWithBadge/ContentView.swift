//
//  ContentView.swift
//  CircleButtonWithBadge
//
//  Created by Macbook on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SDLNotification(badgeCount: 5) {
            
        }
    }
}

struct SDLNotification<Content: View>:View {
    
    let badgeCount: Int
    let content: Content
    
    init(badgeCount: Int, @ViewBuilder content: () -> Content) {
        self.badgeCount = badgeCount
        self.content = content()
    }
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 40))
            .foregroundStyle(.pink)
            .sdlNotificationStyle()
    }
}

struct SDLNotificationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 100, height: 100)
                    .shadow(color: .pink, radius: 5)
                    .overlay(alignment: .bottomTrailing,
                             content: {
                                 Circle()
                                     .fill(Color.blue)
                                     .frame(width: 35, height: 35)
                                     .overlay {
                                         Text("5")
                                             .foregroundStyle(.white)
                                     }
                             })
            )
    }
}

extension View {
    func sdlNotificationStyle() -> some View {
        modifier(SDLNotificationStyle())
    }
}

#Preview {
    ContentView()
}

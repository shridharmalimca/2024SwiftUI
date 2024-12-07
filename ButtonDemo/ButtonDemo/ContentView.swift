//
//  ContentView.swift
//  ButtonDemo
//
//  Created by Macbook on 07/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            SDLButton(title: "Click") {
                debugPrint("Clicked")
            } content: {
                
            }
            .sdlButtonStyle()
        }
        .padding()
    }
}

struct SDLButton<Content: View>:View {
    
    let title: String?
    let action: () -> Void
    let content: Content
    
    init(title: String?, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            if let btnTitle = self.title {
                Text(btnTitle)
            }
        }
    }
}

struct SDLButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
    }
}

extension View {
    func sdlButtonStyle() -> some View {
        modifier(SDLButtonStyle())
    }
}

#Preview {
    ContentView()
}

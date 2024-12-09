//
//  ContentView.swift
//  iOSStopWatch
//
//  Created by Macbook on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isRunningWatch = false
    @State private var lapseTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text(getFormattedTime(lapseTime))
            HStack {
                Button {
                    reset()
                } label: {
                    Text(isRunningWatch ? "Lap" : "Reset").padding()
                }
                .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle).cornerRadius(10)
                    .shadow(radius: 10)
                Spacer()
                Button {
                    startStopTimer()
                } label: {
                    Text(isRunningWatch ? "Stop" : "Start").padding()
                    
                }.buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle).cornerRadius(10)
                    .shadow(radius: 10)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
        .padding()
    }
    
    private func startStopTimer() {
        if isRunningWatch {
            isRunningWatch = false
            lapseTime = 0
            timer?.invalidate()
        } else {
            isRunningWatch = true
            // start timer
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                lapseTime += 0.1
            })
        }
    }
    
    private func reset() {
        isRunningWatch = false
        lapseTime = 0
        timer?.invalidate()
    }
    
    private func getFormattedTime(_ lapsedTime: TimeInterval) -> String {
        // 00: 00: 00
        let minutes = Int(lapsedTime) / 60 // minutes
        let second = Int(lapsedTime) % 60
        let milisecond = Int((lapsedTime * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d:%2d", minutes, second, milisecond)
    }
}

#Preview {
    ContentView()
}

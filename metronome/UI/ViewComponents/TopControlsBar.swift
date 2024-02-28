//
//  TopControlsBar.swift
//  metronome
//
//  Created by Jan Kříž on 19/03/2020.
//  Copyright © 2020 Jan Kříž. All rights reserved.
//

import SwiftUI

@available(iOS 16.0, *)
struct TopControlsBar: View {
    
    @EnvironmentObject var controller: MasterController
    
    @State private var isShowingSettingsView = false
    @State private var tapTimeStamps: Array<Date> = Array()
    
    @State private var counter = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button(action: {
                self.tapTimeStamps.removeAll()
                self.isShowingSettingsView = true
            }) { Image(systemName: "gear") }
                .sheet(isPresented: $isShowingSettingsView) { SettingsView(isOnScreen: self.$isShowingSettingsView).environmentObject(self.controller) }
                .buttonStyle(CustomButtonStyle(size: 65))
                .font(.system(size: 35))
                .accessibility(label: Text("Settings"))
                .frame(width: 70, height: 70)
                .hoverEffect(.highlight)
                .padding(.horizontal, 5)
       }
    }
    func startCounter() {
        timer?.invalidate() // Invalidate any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.counter += 1
        }
    }
    
    func stopCounter() {
        timer?.invalidate()
        timer = nil
    }
}

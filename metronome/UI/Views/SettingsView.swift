//
//  SettingsView.swift
//  metronome
//
//  Created by Jan Kříž on 16/03/2020.
//  Copyright © 2020 Jan Kříž. All rights reserved.
//

import SwiftUI
import MetronomeKit

fileprivate struct Cell: View {
    
    public var action: () -> ()
    public var name: Sounds
    public var currentlySelectedSound: Sounds
    
    private var isSelected: Bool { self.name.rawValue == self.currentlySelectedSound.rawValue }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // This is here just so the whole row is tapable
                Color("settings_background")
                
                HStack {
                    Text(self.name.rawValue)
                        .foregroundColor(isSelected ? Color("text") : Color("text"))
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(isSelected ? .white : .clear)
                        .accessibility(label: isSelected ? Text("Selected") : Text("Not selected"))
                        .padding(.trailing, 15)
                }
            }
            .hoverEffect(.highlight)
            .onTapGesture { self.action() }
            
            Divider()
        }
    }
}



@available(iOS 16.0, *)
struct SettingsView: View {
    
    @EnvironmentObject var controller: MasterController
    
    @Binding var isOnScreen: Bool
    
    @State private var shouldShowEraseAlert               = false
    @State private var shouldShowResetOnAllDevicesMessage = false
    
    var body: some View {
        ZStack {
            Color("settings_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Sounds")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("controls"))
                    
                    Spacer()
                    
                    Button(action: { self.isOnScreen = false }) { Image(systemName: "xmark") }
                        .foregroundColor(Color("controls"))
                        .font(.largeTitle)
                        .accessibility(label: Text("Close settings"))
                        .hoverEffect(.highlight)
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                        Group {
                            Cell(action: { self.controller.selectedSound = .mechanicalMetronomeLow }, name: .mechanicalMetronomeLow, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                            Cell(action: { self.controller.selectedSound = .mechanicalMetronomeHigh }, name: .mechanicalMetronomeHigh, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                            Cell(action: { self.controller.selectedSound = .rimshot }, name: .rimshot, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                            Cell(action: { self.controller.selectedSound = .bassDrum }, name: .bassDrum, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                            Cell(action: { self.controller.selectedSound = .cowbell }, name: .cowbell, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                            Cell(action: { self.controller.selectedSound = .hiHat }, name: .hiHat, currentlySelectedSound: controller.selectedSound).font(.headline).foregroundColor(Color("text"))
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 5)
            }
            .frame(alignment: .topLeading)
        }
    }

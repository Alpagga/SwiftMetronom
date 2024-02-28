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
                    Spacer()
                    
                    Button(action: { self.isOnScreen = false }) { Image(systemName: "xmark") }
                        .foregroundColor(Color("text"))
                        .font(.largeTitle)
                        .accessibility(label: Text("Close settings"))
                        .hoverEffect(.highlight)
						.padding(.top, 15)
						.padding(.trailing, 15)
                }
				
				HStack {
					Text("Sounds")
						.font(.largeTitle)
						.bold()
						.foregroundColor(Color("text"))
						.padding(.leading, -15)
					Spacer()
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
                .padding(.leading, 30)
                .padding(.trailing, 15)
			
				Line()
					.rotation(Angle(degrees: 90))
					.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
					.frame(width: 2)
					.foregroundColor(.white)
					.padding(.top, 10)
					.padding(.bottom, 80)
				
				HStack {
					Text("About")
						.font(.largeTitle)
						.foregroundColor(Color("text"))
						.padding(.leading, 15)
						.bold()
					Spacer()
				}
			
				VStack(alignment: .leading){
						Text("Just a small open-source Project!")
							.foregroundColor(Color("text"))
							.font(.headline)
							.padding(.leading, 30)
							.padding(.trailing, 15)
							.padding(.bottom, 10)
							.padding(.top, 30)

						Text("https://github.com/Alpagga/SwiftMetronom")
							.foregroundColor(Color("text"))
							.font(.headline)
							.padding(.leading, 30)
							.padding(.trailing, 15)
							.padding(.bottom, 10)
						
						Text("Go Steal the Code and Have Fun!")
							.foregroundColor(Color("text"))
							.font(.headline)
							.padding(.leading, 30)
							.padding(.trailing, 15)
							.padding(.bottom, 10)
				}.padding(.top, 150)

            }
            .frame(alignment: .topLeading)
        }
    }


struct Line: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.minX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		return path
	}
}

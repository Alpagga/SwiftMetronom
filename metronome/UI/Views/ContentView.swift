import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @EnvironmentObject var controller: MasterController
    
    var body: some View {
        GeometryReader {geo in
            ZStack {
                Image("wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack {
                    TopControlsBar()

                    
                    HStack{
                        BPMSlider()
                            .padding(.horizontal, 140)
                    }

                    BottomControlsBar()
                        .frame(height: 75)
                        .padding(.bottom, 25)
                        .padding(.top, 20)
                        .padding(.horizontal, 35)
                }
            }
        }
    }
}

import SwiftUI
import AVKit

@available(iOS 16.0, *)
struct ContentView: View {
    
    @EnvironmentObject var controller: MasterController
    
    var body: some View {
//        GeometryReader {geo in
//            ZStack {
//                Image("wallpaper_mov")
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
        GeometryReader {geo in
            PlayerView()
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .top))
            
            ZStack {
                VStack {
                    TopControlsBar()
                    
                    HStack {
                        Spacer()
                        BPMSlider()
                            .frame(maxWidth: 130)
                            .padding(.leading, -32.5)
                            .padding(.trailing, -32.5)
                        Spacer()
                    }
                        
                
                    BottomControlsBar()
                        .frame(height: 75)
                        .padding(.bottom, 12)
                        .padding(.top, 12)
                        .background(Color.black)
                        .padding(.leading, 0)
                        .padding(.trailing, 0)
                }
            }
        }
    }
}


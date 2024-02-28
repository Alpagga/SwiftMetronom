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
            ZStack {
                PlayerView()
                
                VStack {
                    TopControlsBar()

                    
                    HStack{
                        BPMSlider()
                            .padding(.horizontal, 140)
                    }

                    BottomControlsBar()
                        .frame(height: 75)
                        .padding(.bottom, 15)
                        .padding(.top, 10)
                        .padding(.horizontal, 49)
                        .background(Color.black)
                }
            }
        }
    }
}


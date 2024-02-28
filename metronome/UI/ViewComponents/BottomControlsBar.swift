import SwiftUI

@available(iOS 16.0, *)
struct BottomControlsBar: View {
    
    @EnvironmentObject var controller: MasterController
    
    @State private var isShowingSettingsView = false
    @State private var tapTimeStamps: Array<Date> = Array()
    
    @State private var counter = 0
    @State private var counter2 = 0
    @State private var timer: Timer? = nil
    @State private var timer2: Timer? = nil
    
    var body: some View {
        
        HStack{
            Text("\(counter2)")
                .font(Font.custom("Futura", size: 70))
                .foregroundColor(Color("text"))
                .accessibility(label: Text("Current Counter: \(counter2)"))
                .frame(width: 70, alignment: .leading)
            
            Text("\(counter)")
                .font(Font.custom("Futura", size: 70))
                .foregroundColor(Color("text"))
                .accessibility(label: Text("Current Counter: \(counter)"))
                .frame(width: 70, alignment: .leading)
            
            Text("\(controller.bpm)")
                .font(Font.custom("Futura", size: 70))
                .foregroundColor(Color("text"))
                .accessibility(label: Text("Current bpm: \(controller.bpm)"))
                .frame(width: 140 , alignment: .trailing)
        }
        
        HStack {
            
            Button(action: {
                self.controller.setBPM(self.controller.bpm - 1)
            }) { Image(systemName: "minus") }
                .buttonStyle(CustomButtonStyle(size: 55))
                .font(.system(size: 40))
                .accessibility(label: Text("minus 1 bpm"))
                .padding(12)
                .hoverEffect(.highlight)
            
            
            
            Button(action: {
                if self.controller.isPlaying {
                    self.controller.stop()
                    // We want to prepare the buffer here, otherwise it will start playing from where
                    // the the user stopped it, which may start with silence & sound weird
                    self.controller.prepareBuffer()
                    self.stopCounter()
                    self.stopCounter2()
                } else {
                    self.startCounter()
                    self.startCounter2()
                    self.controller.play()
                }
                
                self.tapTimeStamps.removeAll()
                self.controller.isPlaying.toggle()
            }) {
                Image(systemName: controller.isPlaying ? "pause" : "play")
                    .offset(x: controller.isPlaying ? 0 : 3)
                    .foregroundColor(controller.isPlaying ? Color("highlight_2") : Color("highlight"))
            }
            .buttonStyle(CustomButtonStyle(size: 80))
            .font(.system(size: 55))
            .accessibility(label: controller.isPlaying ? Text("pause") : Text("play"))
            .frame(width: 110, height: 110)
            .hoverEffect(.highlight)
            
            
            
            Button(action: {
                self.controller.setBPM(self.controller.bpm + 1)
            }) { Image(systemName: "plus") }
                .buttonStyle(CustomButtonStyle(size: 55))
                .font(.system(size: 40))
                .accessibility(label: Text("plus 1 bpm"))
                .padding(12)
                .hoverEffect(.highlight)
        }
    }
    
    
    func startCounter() {
        self.counter = 1
        
        timer?.invalidate() // Invalidate any existing timer
           
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 4 / Double(controller.bpm), repeats: true) { _ in
            if counter % 4 == 0 && counter != 0{
                self.counter = 0
            } else {
                self.counter += 1
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
       
    func stopCounter() {
        timer?.invalidate()
        timer = nil
    }
    
    func startCounter2() {
        self.counter2 = 0
        
        timer2?.invalidate() // Invalidate any existing timer
           
        timer2 = Timer.scheduledTimer(withTimeInterval: 60 * 4 * 4 / Double(controller.bpm), repeats: true) { _ in
               self.counter2 += 1
        }
        RunLoop.current.add(timer2!, forMode: .common)
    }
       
    func stopCounter2() {
        timer2?.invalidate()
        timer2 = nil
    }
    
}

import SwiftUI


@available(iOS 16.0, *)
struct BPMSlider: View {
    
    @EnvironmentObject var controller: MasterController
    
    @State private var offset: CGFloat = 0.0
    @State private var previousOffset: CGFloat = 0.0
    @State private var sliderValue: CGFloat = 0.0
    // This is hacky... but it works & there's no reason to change it.
    // Basically what this does is prevents the .onReceive modifier from working
    // when the bpm is being set using the slider itself - otherwise it creates a feedback loop
    // and the silder goes either to max or to min bpm.
    @State private var shouldRespondToPublisher = true
    
    var body: some View {
		GeometryReader { geo in
				ZStack{
					RoundedRectangle(cornerRadius: 2)
						.frame(width: 12)
						.foregroundColor(Color("secondary_controls"))
						.shadow(color: Color(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)), radius: 3, x: -3, y: -3)
						.shadow(color: Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)), radius: 3, x: 3, y: 3)
					
					RoundedRectangle(cornerRadius: 2)
						.frame(width: 130, height: 30)
						.foregroundColor(Color("controls"))
						.overlay(
							RoundedRectangle(cornerRadius: 2)
								.frame(width: 100, height: 10)
								.foregroundColor(Color("highlight_2"))
						)
						.offset(y: self.offset)
				}
				.gesture(
					DragGesture(minimumDistance: 5)
						.onChanged { val in
							self.shouldRespondToPublisher = false
							
							if self.controller.isPlaying { self.controller.stop() }
							self.offset = val.translation.height + self.previousOffset
							
							let containingViewHeight = geo.size.height
							if self.offset > (containingViewHeight / 2) {
								self.offset = containingViewHeight / 2
							} else if self.offset < -(containingViewHeight / 2) {
								self.offset = -(containingViewHeight / 2)
							}
							let realValue = (containingViewHeight / 2 + self.offset)
							self.sliderValue = abs((realValue / containingViewHeight) - 1)
							let bpm = Int(self.sliderValue * CGFloat(self.controller.maxBPM - self.controller.minBPM)) + self.controller.minBPM
							
							self.controller.setBPM(bpm)
						}
						.onEnded { _ in
							self.shouldRespondToPublisher = true
							self.previousOffset = self.offset
							self.controller.prepareBuffer()
							if self.controller.isPlaying { self.controller.play() }
						})
				.onAppear {
					let containingViewHeight = geo.size.height
					self.sliderValue = CGFloat(self.controller.bpm - self.controller.minBPM) / CGFloat(self.controller.maxBPM - self.controller.minBPM)
					self.offset = -(self.sliderValue * containingViewHeight - (containingViewHeight / 2))
					self.previousOffset = self.offset
				}
				.onReceive(self.controller.$bpm) { _ in
					guard self.shouldRespondToPublisher else { return }
					
					if self.controller.isPlaying { self.controller.stop() }
					
					let containingViewHeight = geo.size.height
					self.sliderValue = CGFloat(self.controller.bpm - self.controller.minBPM) / CGFloat(self.controller.maxBPM - self.controller.minBPM)
					self.offset = -(self.sliderValue * containingViewHeight - (containingViewHeight / 2))
					self.previousOffset = self.offset
					
					self.controller.prepareBuffer()
					if self.controller.isPlaying { self.controller.play() }
				}
				
			}
		}
    
}

//
//  ShazamMainView.swift
//  ShazamKitDemo
//
//  Created by Tuğçe Arar on 5.12.2021.
//

import SwiftUI

struct ShazamMainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var shazamText : String = "Tap to Shazam"
    
    @State private var isAnimating: Bool = false
    @State private var showingSheet: Bool = false
       var color: Color
       var systemImageName: Image
       var buttonWidth: CGFloat
       var numberOfOuterCircles: Int
       var animationDuration: Double
       var circleArray = [CircleData]()


       init(color: Color = Color.blue, systemImageName: Image = Image("shazamLogo"),  buttonWidth: CGFloat = 48, numberOfOuterCircles: Int = 2, animationDuration: Double  = 1) {
           self.color = color
           self.systemImageName = systemImageName
           self.buttonWidth = buttonWidth
           self.numberOfOuterCircles = numberOfOuterCircles
           self.animationDuration = animationDuration
           
           var circleWidth = self.buttonWidth
           var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
           
           for _ in 0..<numberOfOuterCircles{
               circleWidth += 20
               self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
               opacity -= 0.05
           }
       }

    
    var body: some View {
            ZStack {
                Color.white
                        Group {
                            ForEach(circleArray, id: \.self) { cirlce in
                                Circle()
                                        .fill(self.color)
                                    .opacity(self.isAnimating ? cirlce.opacity : 0)
                                    .frame(width: cirlce.width*2, height: cirlce.width*2, alignment: .center)
                                    .scaleEffect(self.isAnimating ? 1 : 0)
                            }
                            
                        }
                        .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                           value: self.isAnimating)

                        Button(action: {
                            showingSheet = true
                        })
                        {
                            self.systemImageName
                                .resizable()
                                .scaledToFit()
                                .background(Circle().fill(Color.white))
                                .frame(width: self.buttonWidth*2, height: self.buttonWidth*2, alignment: .center)
                                .accentColor(color)
                            
                        }
                        .onAppear(perform: {
                            self.isAnimating.toggle()
                        })
                        .sheet(isPresented: $showingSheet) {
                            ResultView()
                        }
                HStack(){
                    Image("microphone")
                    Button(shazamText){
                        
                    }.font(.system(size: 15, weight: Font.Weight.bold))
                        .foregroundColor(Color.black)
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .onAppear{
                            let baseAnimation = Animation.easeInOut(duration: 3)
                            let repeated = baseAnimation.repeatForever(autoreverses: true)
                            withAnimation(repeated) {
                               //TO DO: Animation
                            }
                        }
                }.frame(width: 500, height: 70, alignment: Alignment.center)
                 .background(Color.white)
                 .padding(EdgeInsets(top: 0, leading: 10, bottom: 250, trailing: 10))
                
            }.background(Color.white)
        }
}

struct ShazamMainView_Previews: PreviewProvider {
    static var previews: some View {
        ShazamMainView()
    }
}

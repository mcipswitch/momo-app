////
////  CircleButton.swift
////  MomoApp
////
////  Created by Priscilla Ip on 2020-09-16.
////
//import SwiftUI
//
//struct CircleButton: View {
//    @State private var showHome: Bool = true
//
//    @State var buttonSize: CGFloat
//
//    @State private var pct: CGFloat = 0
//    @State private var degrees: CGFloat = 0
//    @State private var isDragging: Bool = false
//    @State var isAnimating: Bool = true
//
//    @State private var originalPos = CGPoint.zero
//    @State private var location = CGPoint(x: UIScreen.screenWidth / 2, y: 0)
//    @GestureState private var fingerLocation: CGPoint? = nil
//    @GestureState private var startLocation: CGPoint? = nil
//    @GestureState private var currentLocation: CGPoint? = nil
//
//    @State private var rainbowIsActive: Bool = false
//    private var maxDistance: CGFloat = 36
//    
//    // MARK: - Drag Gestures
//
//    var simpleDrag: some Gesture {
//        DragGesture(minimumDistance: 0)
//            .onChanged { value in
//                self.isDragging = true
//                self.degrees = location.angle(to: originalPos)
//                self.pct = degrees / 360
//
//                if let startLocation = startLocation {
//                    var newLocation = startLocation
//                    newLocation.x += value.translation.width
//                    newLocation.y += value.translation.height
//                    let distance = startLocation.distance(to: newLocation)
//                    if distance > maxDistance {
//
//                        self.rainbowIsActive = (distance > maxDistance * 1.2) ? true : false
//
//                        let k = maxDistance / distance
//                        let locationX = ((newLocation.x - originalPos.x) * k) + originalPos.x
//                        let locationY = ((newLocation.y - originalPos.y) * k) + originalPos.y
//                        self.location = CGPoint(x: locationX, y: locationY)
//                    } else {
//                        self.location = newLocation
//                    }
//                }
//            }.updating($startLocation) { value, startLocation, transaction in
//                // Set startLocation to current rectangle position
//                // It will reset once the gesture ends
//                startLocation = startLocation ?? location
//            }.onEnded { _ in
//                self.location = self.originalPos
//                self.isDragging = false
//                self.rainbowIsActive = false
//            }
//    }
//
//    var fingerDrag: some Gesture {
//        DragGesture(minimumDistance: 0)
//            .updating($fingerLocation) { value, fingerLocation, transaction in
//                fingerLocation = value.location
//            }
//    }
//
//    // MARK: - Body
//
//    var body: some View {
//        let spectrum = Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))])
//        let conic = LinearGradient(gradient: spectrum,
//                                   startPoint: .topLeading,
//                                   endPoint: .bottomTrailing)
//
//        GeometryReader { geometry in
//            ZStack(alignment: .center) {
//                Button(action: self.handleAddEmotion) {
//                    Text("Add today's emotion")
////                        .opacity(showButtonText ? 1 : 0)
////                        .animation(!showButtonText ? .none : Animation
////                                    .easeInOut(duration: 0.2)
////                                    .delay(0.5)
////                        )
//                }.buttonStyle(MomoButton(w: showHome ? 230 : buttonSize, h: showHome ? 60 : buttonSize))
//                .animation(
//                    Animation
//                        .spring(response: 0.8, dampingFraction: 0.5)
//                        .delay(showHome ? 0.2 : 0)
//                )
//
//                if !showHome {
//                    Circle()
//                        .stroke(conic, lineWidth: 6)
//                        .frame(width: buttonSize + 16, height: buttonSize + 16)
//                        .mask(Circle().frame(width: buttonSize + 6))
//                        .hueRotation(Angle(degrees: isAnimating ? 360 : 0))
//                        .animation(
//                            Animation
//                                .easeInOut(duration: 4)
//                                .repeat(while: isAnimating, autoreverses: false)
//                        )
//                        .blur(radius: isAnimating ? 0 : 2)
//                        .opacity(isAnimating ? 1 : 0)
//                        .scaleEffect(isAnimating ? 1 : 1.1)
//                        .animation(isDragging ? .default :
//                                    Animation
//                                    .spring(response: 0.8, dampingFraction: 0.5)
//                                    .delay(1)
//                        )
//                }
//                Button(action: self.handleSeeEntries) {
//                    Text("See all entries")
//                        .underlineText()
//                }
//                .offset(y: 60)
//                .modifier(SlideOut(showHome: $showHome))
//            }
//            .position(self.location)
//            .highPriorityGesture(showHome ? nil : simpleDrag.simultaneously(with: fingerDrag))
//            //    //                            if let fingerLocation = fingerLocation {
//            //    //                                Circle()
//            //    //                                    .stroke(Color.red, lineWidth: 2)
//            //    //                                    .frame(width: 20, height: 20)
//            //    //                                    .position(fingerLocation)
//            //    //                            }
//
//
//
//
//
//
//
//        }
//        .background(Color.orange.opacity(0.05))
//        .onAppear {
//            self.originalPos = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
//            self.location = self.originalPos
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////struct CircleButton: View {
////    @Binding var isDragging: Bool
////    @Binding var isAnimating: Bool
////
////    var body: some View {
////        ZStack {
////            Circle()
////                .fill(
////                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1))]),
////                                   startPoint: .topLeading, endPoint: .bottomTrailing)
////                )
////                .scaleEffect(isDragging ? 1.6 : 1.4)
////                .opacity(isDragging ? 0.5 : 0)
////                .animation(isDragging ? .default : .spring())
////            Circle()
////                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)))
////                .scaleEffect(isAnimating ? 1.5 : 1)
////                .animation(isAnimating ?
////                            Animation
////                            .easeInOut(duration: 1.2)
////                            .repeat(while: isAnimating)
////                            : (isDragging ? .default : .spring())
////                )
////            Circle()
////                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
////                .scaleEffect(isAnimating ? 1.3: 1)
////                .animation(isAnimating ?
////                            Animation
////                            .easeInOut(duration: 1.2)
////                            .repeat(while: isAnimating)
////                            .delay(isAnimating ? 0.2 : 0)
////                            : (isDragging ? .default : .spring())
////                )
////            Circle()
////                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
////                .scaleEffect(isAnimating ? 1 : 1.4)
////                .animation(isAnimating ?
////                            Animation
////                            .easeInOut(duration: 1.2)
////                            .repeat(while: isAnimating)
////                            : (isDragging ? .default : .spring())
////                )
////        }
////        .onChange(of: isDragging) { value in
////            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
////                self.isAnimating = value ? false : true
////            }
////        }
////        .frame(width: 60, height: 60)
////    }
////}

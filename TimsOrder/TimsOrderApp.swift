//
//  TimsOrderApp.swift
//  TimsOrder — Foodies Cafe
//

import SwiftUI

@main
struct TimsOrderApp: App {
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var cartManager    = CartManager()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                ContentView()
                    .environmentObject(orderViewModel)
                    .environmentObject(cartManager)
            }
        }
    }
}

// MARK: - SplashView
// Completely custom logo — dark background, stacked bowl icon with
// decorative food dots, no ember or coffee imagery anywhere.
struct SplashView: View {
    @Binding var showSplash: Bool

    @State private var plateScale:  CGFloat = 0.2
    @State private var plateOpacity: Double = 0.0
    @State private var dot1:        CGFloat = 0.0
    @State private var dot2:        CGFloat = 0.0
    @State private var dot3:        CGFloat = 0.0
    @State private var textOpacity:  Double = 0.0
    @State private var textSlide:   CGFloat = 20

    // Food dot colours
    let dotColors: [Color] = [
        Color(red: 0.96, green: 0.75, blue: 0.20),  // golden yellow
        Color(red: 0.22, green: 0.72, blue: 0.52),  // mint green
        Color(red: 0.93, green: 0.36, blue: 0.36)   // soft red
    ]

    var body: some View {
        ZStack {
            // Deep charcoal background
            Color(red: 0.10, green: 0.12, blue: 0.14).ignoresSafeArea()

            VStack(spacing: 32) {

                // Logo mark — layered circles + bowl icon
                ZStack {
                    // Outer glow ring
                    Circle()
                        .fill(Color(red: 0.10, green: 0.62, blue: 0.49).opacity(0.15))
                        .frame(width: 160, height: 160)

                    // Mid ring
                    Circle()
                        .fill(Color(red: 0.10, green: 0.62, blue: 0.49).opacity(0.25))
                        .frame(width: 128, height: 128)

                    // Inner white circle
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color(red:0.10,green:0.62,blue:0.49).opacity(0.5),
                                radius: 20, y: 8)

                    // Bowl icon
                    Image(systemName: "bowl.fill")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 0.10, green: 0.62, blue: 0.49),
                                         Color(red: 0.05, green: 0.40, blue: 0.30)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )

                    // Floating food dots around the circle
                    foodDot(symbol: "leaf.fill",    color: dotColors[1], offset: CGPoint(x: -62, y: -30), opacity: dot1)
                    foodDot(symbol: "flame.fill",   color: dotColors[2], offset: CGPoint(x:  64, y: -22), opacity: dot2)
                    foodDot(symbol: "drop.fill",    color: dotColors[0], offset: CGPoint(x:   0, y: -72), opacity: dot3)
                }
                .scaleEffect(plateScale)
                .opacity(plateOpacity)

                // App name + tagline
                VStack(spacing: 6) {
                    Text("Foodies Cafe")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Coloured tagline dots
                    HStack(spacing: 6) {
                        Text("Fresh").foregroundColor(dotColors[1])
                        Text("·").foregroundColor(.white.opacity(0.4))
                        Text("Flavourful").foregroundColor(dotColors[0])
                        Text("·").foregroundColor(.white.opacity(0.4))
                        Text("Feel-good").foregroundColor(dotColors[2])
                    }
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .offset(y: textSlide)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            // Plate bounces in
            withAnimation(.spring(response: 0.55, dampingFraction: 0.55).delay(0.1)) {
                plateScale = 1.0; plateOpacity = 1.0
            }
            // Food dots pop in one by one
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.45)) { dot1 = 1.0 }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.6))  { dot2 = 1.0 }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.75)) { dot3 = 1.0 }
            // Text slides up
            withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
                textSlide = 0; textOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation(.easeInOut(duration: 0.4)) { showSplash = false }
            }
        }
    }

    // Helper — small floating icon dot
    func foodDot(symbol: String, color: Color, offset: CGPoint, opacity: CGFloat) -> some View {
        ZStack {
            Circle().fill(color.opacity(0.2)).frame(width: 30, height: 30)
            Image(systemName: symbol).font(.system(size: 13, weight: .bold)).foregroundColor(color)
        }
        .offset(x: offset.x, y: offset.y)
        .opacity(opacity)
        .scaleEffect(opacity)
    }
}

#Preview { SplashView(showSplash: .constant(true)) }

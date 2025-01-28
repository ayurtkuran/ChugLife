import SwiftUI
import SwiftUIGlass

struct GlassBackground: View {
    var body: some View {
        ZStack {
          Color.background
                .ignoresSafeArea()

            GeometryReader { proxy in
                let size = proxy.size

                Circle()
                .fill(Color.progressBarFill.opacity(0.15))
                    .blur(radius: 120)
                    .frame(width: size.width/1.2)
                    .offset(x: -size.width/3, y: -size.height/4)

                Circle()
                .fill(Color.buttonBackground.opacity(0.1))
                    .blur(radius: 150)
                    .frame(width: size.width/1.5)
                    .offset(x: size.width/2.5, y: size.height/3)
            }
        }
    }
}

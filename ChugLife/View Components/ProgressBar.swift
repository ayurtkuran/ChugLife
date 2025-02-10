import SwiftUI
import SwiftUIGlass
import Lottie

struct ProgressBar: View {
    @Binding var progress: Double
    @Binding var target: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Arka plan
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.progressBarBackground)

                // Doluluk animasyonu
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(
                            width: min(
                                CGFloat((self.target > 0 ? self.progress / self.target : 0) * geometry.size.width),
                                geometry.size.width
                            ),
                            height: geometry.size.height
                        )
                        .foregroundColor(Color.progressBarFill)
                        .animation(.linear, value: progress)

                    // Lottie animasyonu
                    LottieView(filename: "Animation - 1739227864292", loopMode: .loop, animationSpeed: 0.1) // Animasyon hızını yavaşlat
                        .frame(
                            width: min(
                                CGFloat((self.target > 0 ? self.progress / self.target : 0) * geometry.size.width),
                                geometry.size.width
                            ),
                            height: geometry.size.height
                        )
                        .scaleEffect(1.5) // Animasyonu küçültmek için
                        .offset(x: -10, y: 0) // Konumunu ayarlamak için
                        .clipped()
                }
            }
            .cornerRadius(10)
        }
    }
}

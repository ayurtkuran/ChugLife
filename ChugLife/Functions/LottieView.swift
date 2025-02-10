import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop
    var animationSpeed: CGFloat = 1.0 // Animasyon hızını kontrol eder

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed // Animasyon hızını ayarla
        animationView.play() // Animasyonu başlat
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // Güncelleme işlemleri için
    }
}

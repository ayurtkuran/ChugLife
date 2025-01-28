import SwiftUI
import SwiftUIGlass

struct ProgressBar: View {
    @Binding var progress: Double
    @Binding var target: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.progressBarBackground)

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
            }
            .cornerRadius(10)
        }
    }
}

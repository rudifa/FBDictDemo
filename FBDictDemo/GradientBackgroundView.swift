import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple, Color.blue]),
            startPoint: .top,
            endPoint: .bottom
        )
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all)
    }
}

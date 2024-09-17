import SwiftUI

struct PhotosView: View {
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    private let gridSpacing: CGFloat = 10
    private let gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    private let imageSize: CGFloat = 100
    private let buttonPadding: CGFloat = 10
    private let buttonCornerRadius: CGFloat = 10

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                        ForEach(viewModel.savedPhotos.keys.sorted(), id: \.self) { key in
                            if let photoCodable = viewModel.savedPhotos[key] {
                                Image(uiImage: photoCodable.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: imageSize, height: imageSize)
                                    .id(key) // Assign an ID to each image
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    // Scroll to the last photo when the view appears
                    if let lastKey = viewModel.savedPhotos.keys.sorted().last {
                        scrollViewProxy.scrollTo(lastKey, anchor: .bottom)
                    }
                }
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .padding(buttonPadding)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(buttonCornerRadius)
                }

                Button(action: {
                    showAlert = true
                }) {
                    Text("Clear All")
                        .padding(buttonPadding)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(buttonCornerRadius)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This will remove all saved photos."),
                        primaryButton: .destructive(Text("Clear All")) {
                            viewModel.clearAllPhotos()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Saved Photos")
        .background(GradientBackgroundView())
    }
}

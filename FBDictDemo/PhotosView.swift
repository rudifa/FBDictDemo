import SwiftUI

struct PhotosView: View {
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                    ForEach(viewModel.savedPhotos.keys.sorted(), id: \.self) { key in
                        if let photoCodable = viewModel.savedPhotos[key] {
                            Image(uiImage: photoCodable.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .padding()
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    showAlert = true
                }) {
                    Text("Clear All")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
    }
}

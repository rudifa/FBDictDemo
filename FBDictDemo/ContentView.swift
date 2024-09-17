import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showPhotosView = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    let fixedSize: CGFloat = 300 // Fixed size for the preview and captured photo

                    GeometryReader { geometry in

                        if viewModel.sessionStarted {
                            CameraView(viewModel: viewModel, frameSize: CGSize(width: fixedSize, height: fixedSize))
                                .frame(width: fixedSize, height: fixedSize)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the camera view
                                .opacity(viewModel.capturedImage == nil ? 1 : 0)
                        }

                        if let image = viewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit) // Ensure the aspect ratio is 1:1
                                .frame(width: fixedSize, height: fixedSize)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                                .clipped()
                                .onAppear {
                                    printt("ZStack.onAppear image.size \(image.size)")
                                }
                        }
                    }
                    .frame(width: fixedSize, height: fixedSize) // Set a fixed frame for the GeometryReader
                }
                Spacer() // Pushes the HStack to the bottom

                HStack {
                    Button(action: {
                        viewModel.clearPhoto()
                    }) {
                        Text("Clear")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }
                    .opacity(viewModel.capturedImage == nil ? 0 : 1)

                    Button(action: {
                        viewModel.capturePhoto()
                    }) {
                        Text("Click")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }

                    ZStack {
                        Button(action: {
                            viewModel.swapCamera()
                        }) {
                            Text("🔄")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                        }
                        .opacity(viewModel.capturedImage == nil ? 1 : 0)

                        Button(action: {
                            viewModel.savePhoto()
                        }) {
                            Text("Save")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                        }
                        .opacity(viewModel.capturedImage == nil ? 0 : 1)
                    }

                    Button(action: {
                        showPhotosView = true
                    }) {
                        Text("Show")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }
                    .sheet(isPresented: $showPhotosView) {
                        PhotosView(viewModel: viewModel)
                    }
                }
                .padding() // Add padding around the HStack
            }
            .onAppear {
                printt("ContentView VStack.onAppear -> startSession")
                viewModel.startSession()
            }
            .navigationTitle("Camera")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

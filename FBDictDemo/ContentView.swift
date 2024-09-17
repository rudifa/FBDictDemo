import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showPhotosView = false

    private let fixedSize: CGFloat = 300
    private let buttonPadding: CGFloat = 10
    private let buttonCornerRadius: CGFloat = 10

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    GeometryReader { geometry in
                        if viewModel.sessionStarted {
                            CameraView(viewModel: viewModel, frameSize: CGSize(width: fixedSize, height: fixedSize))
                                .frame(width: fixedSize, height: fixedSize)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                .opacity(viewModel.capturedImage == nil ? 1 : 0)
                        }

                        if let image = viewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: fixedSize, height: fixedSize)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                .clipped()
                                .onAppear {
                                    printt("ZStack.onAppear image.size \(image.size)")
                                }
                        }
                    }
                    .frame(width: fixedSize, height: fixedSize)
                }
                Spacer()

                HStack {
                    Button(action: {
                        viewModel.clearPhoto()
                    }) {
                        Text("Clear")
                            .padding(buttonPadding)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(buttonCornerRadius)
                            .frame(maxWidth: .infinity)
                    }
                    .opacity(viewModel.capturedImage == nil ? 0 : 1)

                    Button(action: {
                        viewModel.capturePhoto()
                    }) {
                        Text("Click")
                            .padding(buttonPadding)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(buttonCornerRadius)
                            .frame(maxWidth: .infinity)
                    }

                    ZStack {
                        Button(action: {
                            viewModel.swapCamera()
                        }) {
                            Text("🔄")
                                .padding(buttonPadding)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(buttonCornerRadius)
                                .frame(maxWidth: .infinity)
                        }
                        .opacity(viewModel.capturedImage == nil ? 1 : 0)

                        Button(action: {
                            viewModel.savePhoto()
                        }) {
                            Text("Save")
                                .padding(buttonPadding)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(buttonCornerRadius)
                                .frame(maxWidth: .infinity)
                        }
                        .opacity(viewModel.capturedImage == nil ? 0 : 1)
                    }

                    Button(action: {
                        showPhotosView = true
                    }) {
                        Text("Show")
                            .padding(buttonPadding)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(buttonCornerRadius)
                            .frame(maxWidth: .infinity)
                    }
                    .sheet(isPresented: $showPhotosView) {
                        PhotosView(viewModel: viewModel)
                    }
                }
                .padding()
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

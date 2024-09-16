//
//  ContentView.swift
//  test-pkg-access
//
//  Created by Rudolf Farkas on 16.09.24.
//

import SwiftUI

// Main Content View
struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showPhotosView = false

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        CameraView(viewModel: viewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(viewModel.capturedImage == nil ? 1 : 0)

                        if let image = viewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    }
                }
                .frame(height: 300) // Set a fixed height for the preview and captured photo

                if let _ = viewModel.capturedImage {
                    HStack {
                        Button(action: {
                            viewModel.clearPhoto()
                        }) {
                            Text("Clear Photo")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            viewModel.savePhoto()
                        }) {
                            Text("Save Photo")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }

                Button(action: {
                    viewModel.capturePhoto()
                }) {
                    Text("Capture Photo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    showPhotosView = true
                }) {
                    Text("Photos")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showPhotosView) {
                    PhotosView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.startSession()
            }
            .navigationTitle("Camera")
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

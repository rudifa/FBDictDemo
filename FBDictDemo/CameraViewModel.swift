import AVFoundation
import RudifaUtilPkg
import SwiftUI

// ViewModel to handle camera functionality
class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var savedPhotos = FileBackedDictionary<UIImageCodable>(directoryName: "saved-photos")
    @Published var sessionStarted: Bool = false
    @Published var session: AVCaptureSession?
    private var output: AVCapturePhotoOutput?
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    func startSession() {
        guard session == nil else {
            printt("startSession: session already exists")
            return
        }

        session = AVCaptureSession()
        sessionStarted = true // Added to track session start
        session?.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            printt("startSession: failed to get camera device")
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            printt("startSession: failed to create camera input")
            return
        }

        output = AVCapturePhotoOutput()

        if let session {
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                printt("startSession: failed to add input to session")
            }

            if session.canAddOutput(output!) {
                session.addOutput(output!)
            } else {
                printt("startSession: failed to add output to session")
            }
        }

        DispatchQueue.global(qos: .background).async {
            printt("startSession -> session?.startRunning()")
            self.session?.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let output else {
            printt("capturePhoto: output is nil")
            return
        }
        output.capturePhoto(with: settings, delegate: self)
    }

    func clearPhoto() {
        capturedImage = nil
    }

    func savePhoto() {
        guard let image = capturedImage, savedPhotos.count < 120 else {
            printt("savePhoto: No image to save or limit reached")
            return
        }

        let croppedImage = image
        let key = String(format: "image%03d", savedPhotos.count)
        savedPhotos[key] = UIImageCodable(image: croppedImage)
        printt("savedPhoto: \(key) \(image.size) -> \(croppedImage.size)")
        clearPhoto()
    }

    func clearAllPhotos() {
        savedPhotos.removeAll()
    }

    func swapCamera() {
        guard let session else {
            printt("swapCamera: session is nil")
            return
        }
        session.beginConfiguration()

        // Remove existing input
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else {
            printt("swapCamera: current input is nil")
            session.commitConfiguration()
            return
        }
        session.removeInput(currentInput)

        // Get new camera
        let newCameraPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newCameraPosition) else {
            printt("swapCamera: new camera is nil")
            session.addInput(currentInput) // Revert to the original input on error
            session.commitConfiguration()
            return
        }

        // Add new input
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            session.addInput(newInput)
            currentCameraPosition = newCameraPosition
        } catch {
            printt("Error swapping cameras: \(error)")
            session.addInput(currentInput) // Revert to the original input on error
        }

        session.commitConfiguration()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            printt("Error processing photo: \(error.localizedDescription)")
            return
        }

        guard let data = photo.fileDataRepresentation() else {
            printt("Failed to get photo data representation")
            return
        }

        DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                let croppedImage = image.cropToSquare() ?? image
                printt("photoOutput: \(image.size) -> \(croppedImage.size)")
                self.capturedImage = croppedImage
            } else {
                printt("Failed to create UIImage from photo data")
            }
        }
    }
}

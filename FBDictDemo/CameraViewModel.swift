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
        if session != nil {
            return
        }

        session = AVCaptureSession()
        sessionStarted = true // Added to track session start
        session?.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }

        output = AVCapturePhotoOutput()

        if session?.canAddInput(input) == true {
            session?.addInput(input)
        }

        if session?.canAddOutput(output!) == true {
            session?.addOutput(output!)
        }

        DispatchQueue.global(qos: .background).async {
            printt("startSession -> session?.startRunning()")
            self.session?.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output?.capturePhoto(with: settings, delegate: self)
    }

    func clearPhoto() {
        capturedImage = nil
    }

    func savePhoto() {
        if let image = capturedImage, savedPhotos.count < 120 {
            // let croppedImage = image.cropToSquare() ?? image
            let croppedImage = image

            let key = String(format: "image%03d", savedPhotos.count)
            savedPhotos[key] = UIImageCodable(image: croppedImage)
            printt("savedPhoto: \(key) \(image.size) -> \(croppedImage.size)")
            clearPhoto()
        }
    }

    func clearAllPhotos() {
        savedPhotos.removeAll()
    }

    func swapCamera() {
        guard let session else { return }
        session.beginConfiguration()

        // Remove existing input
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        session.removeInput(currentInput)

        // Get new camera
        let newCameraPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newCameraPosition) else { return }

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
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error _: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                let croppedImage = image.cropToSquare() ?? image
                printt("photoOutput: \(image.size) -> \(croppedImage.size)")
                self.capturedImage = croppedImage
            }
        }
    }
}

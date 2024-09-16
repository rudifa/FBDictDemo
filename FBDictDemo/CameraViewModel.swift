import SwiftUI
import AVFoundation
import RudifaUtilPkg

// ViewModel to handle camera functionality
class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var savedPhotos = FileBackedDictionary<UIImageCodable>(directoryName: "saved-photos")
    public var session: AVCaptureSession?
    private var output: AVCapturePhotoOutput?

    func startSession() {
        session = AVCaptureSession()
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
        if let image = capturedImage, savedPhotos.count < 12 {
            let key = "image\(savedPhotos.count)"
            savedPhotos[key] = UIImageCodable(image: image)
            clearPhoto()
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        DispatchQueue.main.async {
            self.capturedImage = UIImage(data: data)
        }
    }
}

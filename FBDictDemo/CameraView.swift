import AVFoundation
import SwiftUI

// Custom Camera View
struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    var frameSize: CGSize

    func makeUIViewController(context _: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black

        if let session = viewModel.session {
            setupPreviewLayer(for: viewController, with: session)
            printt("makeUIViewController -> setupPreviewLayer")
        } else {
            printt("makeUIViewController: session == nil")
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context _: Context) {
        if let session = viewModel.session {
            if let previewLayer = uiViewController.view.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
                if previewLayer.session != session {
                    previewLayer.session = session
                    printt("updateUIViewController: previewLayer.session = session")
                }
            } else {
                setupPreviewLayer(for: uiViewController, with: session)
                printt("updateUIViewController -> setupPreviewLayer")
            }
        }
    }

    private func setupPreviewLayer(for viewController: UIViewController, with session: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = CGRect(origin: .zero, size: frameSize)
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
    }
}

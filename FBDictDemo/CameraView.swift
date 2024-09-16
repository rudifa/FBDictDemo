import AVFoundation
import SwiftUI

import AVFoundation
import SwiftUI


// Custom Camera View
struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black

        if let session = viewModel.session {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = viewController.view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            viewController.view.layer.addSublayer(previewLayer)
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let session = viewModel.session {
            if let previewLayer = uiViewController.view.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
                previewLayer.session = session
            } else {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.frame = uiViewController.view.bounds
                previewLayer.videoGravity = .resizeAspectFill
                uiViewController.view.layer.addSublayer(previewLayer)
            }
        }
    }
}


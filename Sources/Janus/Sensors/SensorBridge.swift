import AVFoundation

public class JanusSensorBridge {
    public static let shared = JanusSensorBridge()
    public init() {}
    public func requestAndStartCapture() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted { print("🎤 NSMicrophonePermission → Flux audio actif") }
        }
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted { print("📹 NSCameraPermission → Flux vidéo actif") }
        }
    }
}

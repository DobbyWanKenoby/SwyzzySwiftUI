////
////  CameraService.swift
////  SwyzzySwiftUI
////
////  Created by Василий Усов on 14.02.2022.
////
//
//import Foundation
//import AVFoundation
//
//protocol CameraService {
//    
//}
//
//class BaseCameraService: CameraService {
//    typealias PhotoCaptureSessionID = String
//        
//    //    MARK: Observed Properties UI must react to
//        
//    //    1.
//        @Published public var flashMode: AVCaptureDevice.FlashMode = .off
//    //    2.
//        @Published public var shouldShowAlertView = false
//    //    3.
//        @Published public var shouldShowSpinner = false
//    //    4.
//        @Published public var willCapturePhoto = false
//    //    5.
//        @Published public var isCameraButtonDisabled = true
//    //    6.
//        @Published public var isCameraUnavailable = true
//    //    8.
//        @Published public var photo: Photo?
//    
//    // ...
//    // MARK: Alert properties
//        public var alertError: AlertError = AlertError()
//        
//    // MARK: Session Management Properties
//        
//    //    9. The capture session.
//        public let session = AVCaptureSession()
//        
//    //    10. Stores whether the session is running or not.
//        private var isSessionRunning = false
//        
//    //    11. Stores wether the session is been configured or not.
//        private var isConfigured = false
//        
//    //    12. Stores the result of the setup process.
//        private var setupResult: SessionSetupResult = .success
//        
//    //    13. The GDC queue to be used to execute most of the capture session's processes.
//        private let sessionQueue = DispatchQueue(label: "camera session queue")
//        
//    //    14. The device we'll use to capture video from.
//        @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
//
//    // MARK: Device Configuration Properties
//    //    15. Video capture device discovery session.
//        private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
//
//    // MARK: Capturing Photos Properties
//    //    16. PhotoOutput. Configures and captures photos.
//        private let photoOutput = AVCapturePhotoOutput()
//        
//    //    17 Stores delegates that will handle the photo capture process's stages.
//        private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
//
//    // ...
//    
//    //        MARK: Checks for user's permisions
//        public func checkForPermissions() {
//          
//            switch AVCaptureDevice.authorizationStatus(for: .video) {
//            case .authorized:
//                // The user has previously granted access to the camera.
//                break
//            case .notDetermined:
//                /*
//                 The user has not yet been presented with the option to grant
//                 video access. Suspend the session queue to delay session
//                 setup until the access request has completed.
//                 */
//                sessionQueue.suspend()
//                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
//                    if !granted {
//                        self.setupResult = .notAuthorized
//                    }
//                    self.sessionQueue.resume()
//                })
//                
//            default:
//                // The user has previously denied access.
//                // Store this result, create an alert error and tell the UI to show it.
//                setupResult = .notAuthorized
//                
//                DispatchQueue.main.async {
//                    self.alertError = AlertError(title: "Camera Access", message: "SwiftCamera doesn't have access to use your camera, please update your privacy settings.", primaryButtonTitle: "Settings", secondaryButtonTitle: nil, primaryAction: {
//                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
//                                                      options: [:], completionHandler: nil)
//                        
//                    }, secondaryAction: nil)
//                    self.shouldShowAlertView = true
//                    self.isCameraUnavailable = true
//                    self.isCameraButtonDisabled = true
//                }
//            }
//        }
//    
//    //  MARK: Session Managment
//        
//        // Call this on the session queue.
//        /// - Tag: ConfigureSession
//        private func configureSession() {
//            if setupResult != .success {
//                return
//            }
//            
//            session.beginConfiguration()
//            
//            session.sessionPreset = .photo
//            
//            // Add video input.
//            do {
//                var defaultVideoDevice: AVCaptureDevice?
//                
//                if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
//                    // If a rear dual camera is not available, default to the rear wide angle camera.
//                    defaultVideoDevice = backCameraDevice
//                } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
//                    // If the rear wide angle camera isn't available, default to the front wide angle camera.
//                    defaultVideoDevice = frontCameraDevice
//                }
//                
//                guard let videoDevice = defaultVideoDevice else {
//                    print("Default video device is unavailable.")
//                    setupResult = .configurationFailed
//                    session.commitConfiguration()
//                    return
//                }
//                
//                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
//                
//                if session.canAddInput(videoDeviceInput) {
//                    session.addInput(videoDeviceInput)
//                    self.videoDeviceInput = videoDeviceInput
//                    
//                } else {
//                    print("Couldn't add video device input to the session.")
//                    setupResult = .configurationFailed
//                    session.commitConfiguration()
//                    return
//                }
//            } catch {
//                print("Couldn't create video device input: \(error)")
//                setupResult = .configurationFailed
//                session.commitConfiguration()
//                return
//            }
//            
//            // Add the photo output.
//            if session.canAddOutput(photoOutput) {
//                session.addOutput(photoOutput)
//                
//                photoOutput.isHighResolutionCaptureEnabled = true
//                photoOutput.maxPhotoQualityPrioritization = .quality
//                
//            } else {
//                print("Could not add photo output to the session")
//                setupResult = .configurationFailed
//                session.commitConfiguration()
//                return
//            }
//            
//            session.commitConfiguration()
//            self.isConfigured = true
//            
//            self.start()
//        }
//}
//
//public struct Photo: Identifiable, Equatable {
////    The ID of the captured photo
//    public var id: String
////    Data representation of the captured photo
//    public var originalData: Data
//    
//    public init(id: String = UUID().uuidString, originalData: Data) {
//        self.id = id
//        self.originalData = originalData
//    }
//}
//
//public struct AlertError {
//    public var title: String = ""
//    public var message: String = ""
//    public var primaryButtonTitle = "Accept"
//    public var secondaryButtonTitle: String?
//    public var primaryAction: (() -> ())?
//    public var secondaryAction: (() -> ())?
//    
//    public init(title: String = "", message: String = "", primaryButtonTitle: String = "Accept", secondaryButtonTitle: String? = nil, primaryAction: (() -> ())? = nil, secondaryAction: (() -> ())? = nil) {
//        self.title = title
//        self.message = message
//        self.primaryAction = primaryAction
//        self.primaryButtonTitle = primaryButtonTitle
//        self.secondaryAction = secondaryAction
//    }
//}

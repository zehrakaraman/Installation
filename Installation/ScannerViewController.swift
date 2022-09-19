//
//  ViewController.swift
//  QRCode Scanner
//
//  Created by Zehra on 1.08.2022.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissions()
        setupCameraLiveView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Stop session
        captureSession.stopRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backNewInstallation" {
            if let code = sender as? String {
                let destinationVC = segue.destination as! NewInstallationViewController
                destinationVC.viewModel.QRCode = code
            }
        }
    }

}

extension ScannerViewController {
    
    private func checkPermissions() {
      // Checking permissions
        switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { [self] granted in
          if !granted {
            self.showPermissionsAlert()
          }
        }
      case .denied, .restricted:
        showPermissionsAlert()
      default:
        return
      }
    }
    
    private func setupCameraLiveView() {
        
        // Add input
        let device = bestDevice(in: .back)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(videoDeviceInput) else{
            showAlert(
              withTitle: "Cannot initialize videoDeviceInput",
              message: "There seems to be a problem with the camera on your device.")
            return
        }
        
        captureSession.addInput(videoDeviceInput)
        
        // Add output
        let captureOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(captureOutput) {
            
            captureSession.addOutput(captureOutput)
            captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureOutput.metadataObjectTypes = [
                .qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce
            ]
                
            
        } else {
            return
        }
        
        configurePreviewLayer()
        
        // Run session
        captureSession.startRunning()
    
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let first = metadataObjects.first {
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            found(code: stringValue)
        } else {
            print("No able to read the code. Please, try again or be keep your device on QR code.")
        }
    
    }
    
    func found(code: String) {
        performSegue(withIdentifier: "backNewInstallation", sender: code)
    }
    
}

extension ScannerViewController {
    func returnValue(code: String) -> String? {
        return code
    }
    
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(cameraPreviewLayer)
        
    }
    
    private func showPermissionsAlert() {
      showAlert(
        withTitle: "Camera Permissions",
        message: "Please open Settings and grant permission for this app to use your camera.")
    }
    
    private func showAlert(withTitle title: String, message: String) {
      DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
      }
    }
    
    func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video, position: .unspecified)
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}

        return devices.first(where: { device in device.position == position })!
    }
    
}




//
//  QRCodeReader.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReader: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    enum error: Error {
        case noCameraAvailable
        case videoInputFail
    }
    
    var video = AVCaptureVideoPreviewLayer ()
    
    
    @IBOutlet weak var cameraPreview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //begin my session
        let session = AVCaptureSession()
        
        //capture my device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //try to get the camerea
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            session.addInput(input)
        } catch {
            print("Error to initialize")
        }
        
        //camera output
        let output = AVCaptureMetadataOutput()
        
        //start the session to recognize QR codes
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = cameraPreview.layer.bounds
        cameraPreview.layer.addSublayer(video)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
         if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    print(object.stringValue!)
                }
            }
        }
        
    }

    @IBAction func goBack(_ sender: Any) { navigationController?.popViewController(animated: false)
    }
    
}

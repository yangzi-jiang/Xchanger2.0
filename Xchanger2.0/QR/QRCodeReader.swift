//
//  QRCodeReader.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Firebase

class QRCodeReader: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    enum error: Error {
        case noCameraAvailable
        case videoInputFail
    }
    
    var recognized = false
    var video = AVCaptureVideoPreviewLayer ()
    
    
    
    @IBOutlet weak var cameraPreview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureCamera))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureCamera))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        //begin my session
        let session = AVCaptureSession()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    self.setupCamera(session: session)
                
                case .notDetermined: // The user has not yet been asked for camera access.
                    print("not determined")
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            self.setupCamera(session: session)
                        }
                    }
                
                case .denied: // The user has previously denied access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            self.setupCamera(session: session)
                        }
                    }
                    return
                
                case .restricted: // The user can't grant access due to restrictions.
                    return
        }
        
       
        
        
    }
    
    func setupCamera(session: AVCaptureSession){
        
        //        let captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        //capture my device
        let captureDevice = findDevice()
        //
        //try to get the camerea
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            session.addInput(input)
        } catch {
            print("Error to initialize")
        }
        
        let output = AVCaptureMetadataOutput()
        
        //start the session to recognize QR codes
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        DispatchQueue.main.async {
            self.video = AVCaptureVideoPreviewLayer(session: session)
            self.video.frame = self.cameraPreview.layer.bounds
            self.cameraPreview.layer.addSublayer(self.video)
            session.startRunning()
        }
        
    }
    
    
    func findDevice() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
            print("here")
            
            return device
        } else {
            fatalError("Missing expected back camera device.")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if(!recognized) {
         if metadataObjects != nil && metadataObjects.count != 0 {
            recognized = true
            print("recognized QR")
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                print("there is an object")
                if object.type == AVMetadataObject.ObjectType.qr {
                    print("inside here")
                    print(Auth.auth().currentUser!.uid)
                    print(object.stringValue!) //no string value here?
                    
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    
                    generator.impactOccurred()
                    let connectPersonId = object.stringValue!
                    

                    
                    
                    // Update what the connected person could see
                    
                    let available0 = Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid)
                    
                    let available1 = Database.database().reference().root.child("available").child(connectPersonId).child(Auth.auth().currentUser!.uid)
                    
                    available0.observeSingleEvent(of: .value) { (snapshot) in
                        let dictionary = snapshot.value as? NSDictionary
                        available1.setValue(dictionary)
                    }
                    
                    // Update what the current person could see
                    
                    let available2 = Database.database().reference().root.child("shares").child(connectPersonId)
                   
                    
                    let available3 = Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child(connectPersonId)
                    
                    available2.observeSingleEvent(of: .value) { (snapshot) in
                        let dictionary = snapshot.value as? NSDictionary
                        available3.setValue(dictionary)
                    }
                    
                    
                    let refName = Database.database().reference().root.child("full_names").child(connectPersonId)
                    
                    refName.observeSingleEvent(of: .value, with: { (snapshot) in
                        let name = snapshot.value as? String
                        let alert = UIAlertController(title: "Contact Xchanged", message: "You have added " + name! + "!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: { action in
                            //run your function here
                            self.navigationController?.popViewController(animated: false)
                        }))
                        
                        self.present(alert, animated: true)
                    })
                    
                    let ref1 = Database.database().reference().root.child("exchanges").child(Auth.auth().currentUser!.uid).child(connectPersonId)
                    
                    var coordinates = [Float]()
                    coordinates.append(Float(userLongitude))
                    coordinates.append(Float(userLatitude))
                    
                    ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                        ref1.setValue(coordinates)
                    })
                    
                    let ref2 = Database.database().reference().root.child("exchanges").child(connectPersonId).child(Auth.auth().currentUser!.uid)
                    
                    ref2.observeSingleEvent(of: .value, with: { (snapshot) in
                        ref2.setValue(coordinates)
                    })
                    
                    
                
                    
                    
                    
                
                    
                    
//                    
//                    navigationController?.popViewController(animated: false)
                }
            }
        }
    }
}

    @IBAction func goBack(_ sender: Any) { navigationController?.popViewController(animated: false)
    }
    
    
    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
    
     @objc func handleGestureCamera(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}

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
        if(!recognized) {
         if metadataObjects != nil && metadataObjects.count != 0 {
            recognized = true
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    print(object.stringValue!)
                    
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

//
//  PhotoViewController.swift
//  AVCam
//
//  Created by Németh Bendegúz on 2017. 10. 04..
//  Copyright © 2017. Apple. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders
import Accelerate
import AVFoundation

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var Net: Inception3Net? = nil
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var textureLoader : MTKTextureLoader!
    var ciContext : CIContext!
    var sourceTexture : MTLTexture? = nil
    
    var image: UIImage!
    
    var imageFromPhotoLibrary: UIImage! {
        didSet {
            imageView.image = imageFromPhotoLibrary
            image = imageFromPhotoLibrary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func usePhoto(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.blurView.isHidden = false
            self.view.setNeedsDisplay()
        }
        
        // Load default device.
        device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard MPSSupportsMTLDevice(device) else {
            print("Metal Performance Shaders not Supported on current Device")
            return
        }
        
        // Load any resources required for rendering.
        
        // Create new command queue.
        commandQueue = device!.makeCommandQueue()
        
        // make a textureLoader to get our input images as MTLTextures
        textureLoader = MTKTextureLoader(device: device!)
        
        // Load the appropriate Network
        Net = Inception3Net(withCommandQueue: commandQueue)
        
        // we use this CIContext as one of the steps to get a MTLTexture
        ciContext = CIContext.init(mtlDevice: device)
        
        // get a texture from UIImage
        do {
            sourceTexture = try FishPredictor.createSourceTexture(from: image, with: ciContext, and: textureLoader)
        }
        catch let error as NSError {
            fatalError("Unexpected error ocurred: \(error.localizedDescription).")
        }
        
        let myWebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
        
        if imageFromPhotoLibrary != nil {
            myWebViewController.isCameraButtonHidden = false
        }
        
        // run inference neural network to get predictions and display them
        myWebViewController.textOfLabel = FishPredictor.runNetwork(Net!, with: sourceTexture!, and: commandQueue)
        self.present(myWebViewController, animated: true, completion: { self.blurView.isHidden = true })
        
    }
    
}


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
    
    var image2: UIImage! {
        didSet {
            imageView.image = image2
            image = image2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        imageView.image = image
//        super.viewWillAppear(animated)
//    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func usePhoto(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: blurView)
        blurView.isHidden = false
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.tag = 100
//        self.view.addSubview(blurEffectView)
//        self.view.bringSubview(toFront: blurEffectView)
        
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
        
        if image2 != nil {
            myWebViewController.isCameraButtonHidden = false
        }
        
        // run inference neural network to get predictions and display them
        myWebViewController.textOfLabel = FishPredictor.runNetwork(Net!, with: sourceTexture!, and: commandQueue)
        self.present(myWebViewController, animated: true, completion: { self.blurView.isHidden = true })
        
    }
    
}


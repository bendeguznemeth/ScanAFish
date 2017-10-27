//
//  PreviewView.swift
//  AVCam
//
//  Created by Németh Bendegúz on 2017. 10. 02..
//  Copyright © 2017. Apple. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        return layer
    }
	
	var session: AVCaptureSession? {
		get {
			return videoPreviewLayer.session
		}
		set {
			videoPreviewLayer.session = newValue
		}
	}
	
	// MARK: UIView
	
    override class var layerClass: AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
}


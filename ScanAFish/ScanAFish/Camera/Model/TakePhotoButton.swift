//
//  TakePhotoButton.swift
//  AVCam
//
//  Created by Németh Bendegúz on 2017. 10. 02..
//  Copyright © 2017. Apple. All rights reserved.
//

import UIKit

// MARK: Protocol Declaration

// Delegate for TakePhotoButton

protocol TakePhotoButtonDelegate: class {
    
    // Called when UITapGestureRecognizer begins
    
    func buttonWasTapped()
    
}

// MARK: View Declaration

// UIButton Subclass for Capturing Photos with CameraViewController

class TakePhotoButton: UIButton {
    
    private var circleBorder: CALayer!
    private var innerCircle: UIView!
    
    // Delegate variable
    
    public weak var delegate: TakePhotoButtonDelegate?
    
    // Initialization Declaration
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createGestureRecognizers()
        drawButton()
    }
    
    // Initialization Declaration
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
        drawButton()
    }
    
    
    
    private func drawButton() {
        self.backgroundColor = UIColor.clear
        
        circleBorder = CALayer()
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = 6.0
        circleBorder.borderColor = UIColor.white.cgColor
        circleBorder.bounds = self.bounds
        circleBorder.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)
        
    }
    
    // UITapGestureRecognizer Function
    
    @objc fileprivate func Tap() {
        delegate?.buttonWasTapped()
    }
    
    // Add Tap gesture recognizer
    
    fileprivate func createGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TakePhotoButton.Tap))
        self.addGestureRecognizer(tapGesture)
    }
}


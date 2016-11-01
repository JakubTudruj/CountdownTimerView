//
//  CircularLoaderView.swift
//  ScrabbleHelper
//
//  Created by Jakub Tudruj on 09/10/2016.
//  Copyright © 2016 Jakub Tudruj. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {
    
    //MARK: - public vars
    public var circleRadius: CGFloat = 20.0
    
    public var progress: CGFloat {
        get {
            return _circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                _circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                _circlePathLayer.strokeEnd = 0
            } else {
                _circlePathLayer.strokeEnd = newValue
            }
            self.setupRingColor(progress: Double(newValue))
        }
    }
    
    public var ringColors: [UIColor] {
        get {
            while _ringColors.count < 3 {
                _ringColors.append(_ringColors.last!)
            }
            return _ringColors
            
        }
        set {
            _ringColors = newValue
        }
    }
    
    public var fillColor: UIColor = UIColor.clear
    
    public var lineWidth: CGFloat = 4
    
    //MARK: - private vars
    private var _ringColors = [UIColor.green, UIColor.yellow, UIColor.red]
    private let _circlePathLayer = CAShapeLayer()
    
    //MARK: - implementation
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup view
    
    func setupRingColor(progress: Double) {
        if progress > 0.4 {
            _circlePathLayer.strokeColor = self.ringColors[0].cgColor
        } else if progress > 0.15 {
            _circlePathLayer.strokeColor = self.ringColors[1].cgColor
        } else {
            _circlePathLayer.strokeColor = self.ringColors[2].cgColor
        }
    }
    
    func setup() {
        self.layer.addSublayer(self._circlePathLayer)
        self.progress = 0
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*self.circleRadius, height: 2*self.circleRadius)
        circleFrame.origin.x = _circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = _circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: self.circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _circlePathLayer.frame = bounds
        self.backgroundColor = UIColor.clear
        _circlePathLayer.fillColor = self.fillColor.cgColor
        _circlePathLayer.lineWidth = self.lineWidth
        _circlePathLayer.path = self.circlePath().cgPath
    }

}

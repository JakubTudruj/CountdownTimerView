//
//  CountdownView.swift
//  ScrabbleHelper
//
//  Created by Jakub Tudruj on 09/10/2016.
//  Copyright © 2016 Jakub Tudruj. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    public static let TimerDidStart = NSNotification.Name("TimerDidStart")
    public static let TimerDidResume = NSNotification.Name("TimerDidResume")
    public static let TimerDidPause = NSNotification.Name("TimerDidPause")
    public static let TimerDidFinish = NSNotification.Name("TimerDidFinish")
}

class CountdownTimerView: UIView {
    //MARK: - public vars
    public var secondsToCountdown: Int {
        get {
            return Int(_secondsToCountdown)
        }
        set {
            self.timerLabel.text = ""
            _secondsToCountdown = Double(newValue)
            self.timerActual = Double(newValue)
            self.updateTimerLabel()
        }
    }
    
    public var secondsToEnd: Int {
        get {
            return Int(self.timerActual)
        }
    }
    
    public var secondsFromBeginning: Int {
        get {
            return self.secondsToCountdown - Int(self.timerActual)
        }
    }
    
    public var isTimerStarted: Bool {
        get {
            return _isTimerStarted
        }
    }
    
    public var isTimerFinished: Bool {
        get {
            return _isTimerFinished
        }
    }
    
    public var isTimerPaused: Bool {
        get {
            return _isTimerPaused
        }
    }
    
    public var progress: CGFloat {
        get {
            return self.circularIndicatorView.progress
        }
    }
    
    public var delegate: CountdownTimerDelegate?
    
    //MARK: circularLoader config vars
    
    public var ringColors: [UIColor] {
        get {
            return self.circularIndicatorView.ringColors
        }
        set {
            self.circularIndicatorView.ringColors = newValue
        }
    }
    
    public var ringLineWidth: CGFloat {
        get {
            return self.circularIndicatorView.lineWidth
        }
        set {
            self.circularIndicatorView.lineWidth = newValue
        }
    }
    
    //MARK: - private vars
    private var _secondsToCountdown: Double = 60
    private var _isTimerStarted: Bool = false
    private var _isTimerFinished: Bool = false
    private var _isTimerPaused: Bool = false
    
    private let circularIndicatorView = CircularLoaderView(frame: CGRect.zero)
    private var timerLabel: UILabel!
    private var timerActual: Double!
    private var timer: Timer = Timer()

    //MARK: - public methods
    public func startNewTimer(seconds: Int) {
        self.secondsToCountdown = seconds
        self.startTimer()
        self.delegate?.timerDidStart?(sender: self)
        NotificationCenter.default.post(name: NSNotification.Name.TimerDidStart, object: nil)
    }
    
    public func startNewTimer() {
        self.startNewTimer(seconds: self.secondsToCountdown)
    }
    
    public func pauseTimer() {
        self.timer.invalidate()
        _isTimerPaused = true
        self.delegate?.timerDidPause?(sender: self)
        NotificationCenter.default.post(name: NSNotification.Name.TimerDidPause, object: nil)
    }
    
    public func resumeTimer() {
        self.startTimer()
        self.delegate?.timerDidResume?(sender: self)
        NotificationCenter.default.post(name: NSNotification.Name.TimerDidResume, object: nil)
    }
    
    public func stopTimer() {
        if !self.isTimerStarted || self.isTimerFinished {
            return
        }
        self.timer.invalidate()
        _isTimerFinished = true
        _isTimerStarted = false
        _isTimerPaused = false
        self.resetTimerLabel()
        self.delegate?.timerDidFinish?(sender: self)
        NotificationCenter.default.post(name: NSNotification.Name.TimerDidFinish, object: nil)
    }
    
    //MARK: - timer private methods
    internal func startTimer() {
        _isTimerStarted = true
        _isTimerFinished = false
        _isTimerPaused = false
        self.timerLabel.text = ""
        self.timer.invalidate() //stops timer if exists before
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    //MARK: - system methods
    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.circularIndicatorView.progress = 1
        self.timerActual = Double(self.secondsToCountdown)
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        self.setupCircularIndicatorView()
        self.setup()
    }
    
    override internal func draw(_ rect: CGRect) {
        super.draw(rect)
        self.updateTimerLabel()
    }
    
    //MARK: helpers
    internal func updateTimerLabel() {
        self.timerLabel.text = self.secondsToHoursMinutesSecondsString(seconds: Int(ceil(self.timerActual)))
        
        
        if (self.timerActual >= 0) {
            if _isTimerStarted {
                self.timerActual = round(self.timerActual * 10 - 1)/10
            }
            self.circularIndicatorView.progress = CGFloat(self.timerActual / _secondsToCountdown)
        } else {
            _isTimerFinished = true
            self.timer.invalidate()
            self.delegate?.timerDidFinish?(sender: self)
            NotificationCenter.default.post(name: NSNotification.Name.TimerDidFinish, object: nil)
        }
        self.delegate?.timerDidReachTime?(sender: self, secondsToEnd: Int(ceil(self.timerActual)))
    }
    
    internal func resetTimerLabel() {
        self.timerActual = _secondsToCountdown
        self.updateTimerLabel()
    }
    
    internal func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    internal func secondsToHoursMinutesSecondsString(seconds:Int) -> (String) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: seconds)
        var text = String(s)
        if text.characters.count == 1 {
            text = "0\(text)"
        }
        if m > 0 {
            text = "\(String(m)):\(text)"
        }
        if h > 0 {
            text = "\(String(h)):\(text)"
        }
        return text
    }
    
    //MARK: setup view elements
    internal func setup() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.circularIndicatorView)
        self.setupTimerLabel()
        self.addSubview(self.timerLabel)
    }
    
    internal func setupTimerLabel() {
        self.timerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.timerLabel.textAlignment = .center
    }

    internal func setupCircularIndicatorView() {
        let circleRadious = CGFloat([self.frame.width, self.frame.height].min()! / 2)
        self.circularIndicatorView.circleRadius = circleRadious
        self.circularIndicatorView.frame = self.bounds
        self.circularIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}


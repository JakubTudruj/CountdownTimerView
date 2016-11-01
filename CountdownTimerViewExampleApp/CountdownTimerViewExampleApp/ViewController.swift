//
//  ViewController.swift
//  CountdownTimerViewExampleApp
//
//  Created by Jakub Tudruj on 01/11/2016.
//  Copyright © 2016 Jakub Tudruj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountdownTimerDelegate {

    @IBOutlet weak var countDownView: CountdownTimerView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        self.countDownView.delegate = self
        self.countDownView.secondsToCountdown = 65
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideWarningLabel), name: NSNotification.Name.TimerDidStart, object: nil)
        /*
         uncomment line below to see effects
         */
//        self.setupCountdownView();
    }
    
    func setupCountdownView() {
        self.countDownView.ringColors = [UIColor.cyan, UIColor.orange, UIColor.red]
        self.countDownView.fillColor = UIColor.blue
        self.countDownView.ringLineWidth = 8
        
        self.countDownView.labelFont = UIFont.boldSystemFont(ofSize: 25)
        self.countDownView.labelColor = UIColor.brown
    }
    
    //MARK: Buttons
    @IBAction func hourButtonClicked(_ sender: AnyObject) {
        self.countDownView.secondsToCountdown = 60*60 + 20*60
    }
    
    @IBAction func minuteButtonClicked(_ sender: AnyObject) {
        self.countDownView.secondsToCountdown = 3*60
    }
    
    @IBAction func secondsButtonClicked(_ sender: AnyObject) {
        self.countDownView.secondsToCountdown = 10
    }
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        if self.countDownView.isTimerStarted && !self.countDownView.isTimerFinished && !self.countDownView.isTimerPaused{
            self.countDownView.pauseTimer()
            sender.setTitle("Resume", for: .normal)
        } else if self.countDownView.isTimerPaused {
            self.countDownView.resumeTimer()
            sender.setTitle("Pause", for: .normal)
        } else {
            self.countDownView.startNewTimer()
            sender.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: AnyObject) {
        self.countDownView.stopTimer()
    }
    
    //MARK: Notification method
    func hideWarningLabel() {
        self.warningLabel.isHidden = true
    }
    
    //MARK: CountdownViewDelegate
    func timerDidFinish(sender: CountdownTimerView) {
        self.startButton.setTitle("START!", for: .normal)
        let alert = UIAlertController(title: "Warning!", message: "Timer has stopped!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func timerDidReachTime(sender: CountdownTimerView, secondsToEnd: Int) {
        if secondsToEnd == 3 {
            self.warningLabel.isHidden = false
        }
    }

}


//
//  CountdownDelegate.swift
//  ScrabbleHelper
//
//  Created by Jakub Tudruj on 27/10/2016.
//  Copyright © 2016 Jakub Tudruj. All rights reserved.
//

import Foundation

@objc protocol CountdownTimerDelegate {
    
    @objc optional func timerDidStart(sender: CountdownTimerView)
        
    @objc optional func timerDidResume(sender: CountdownTimerView)
    
    @objc optional func timerDidPause(sender: CountdownTimerView)
    
    @objc optional func timerDidFinish(sender: CountdownTimerView)
    
    @objc optional func timerDidReachTime(sender: CountdownTimerView, secondsToEnd: Int)
    
}

# CountdownTimerView

CountdownTimerView is a timer with rounded indicator based on UIView.
The repository contains example application with proposition of use and configure.
Project is written in Swift 3.

![Alt preview](http://i.imgur.com/OqMvYXI.png)
![Alt preview](http://i.imgur.com/ZTTV7CD.gif)

# Installation

## Manually

Just copy files from <i>Sources</i> to your project.

# Usage

## Embeding view

Add to your ViewController an UIView and set its class as CountdownTimerView

![Alt embeding](http://i.imgur.com/PPceWX8.gif)

## Configuration

Make IBOutlet of the UIVIew and set few properties

### Appereance

label color (default: black):
``` Swift
self.timerView.labelColor = UIColor.red
```

indicator line color (default: array of: green, yellow, red):
``` Swift
self.timerView.ringColors = [UIColor.red, UIColor.green, UIColor.blue]
```

indicator fill color (default: clear):
``` Swift
self.timerView.fillColor = UIColor.clear
```

indicator line width (default: 4):
``` Swift
self.timerView.ringLineWidth = 5
```

### Timer configuration

set secconts to coutdown (default: 60):
``` Swift
self.timerView.secondsToCountdown = 120
```

start new timer method (gets time from secondsToContdown property):
``` Swift
self.timerView.startNewTimer()
```

start new timer method with time in parameter:
``` Swift
self.timerView.startNewTimer(seconds: 350)
```

pause timer method:
``` Swift
self.timerView.pauseTimer()
```

resume started timer method:
``` Swift
self.timerView.resumeTimer()
```

stop timer method:
``` Swift
self.timerView.stopTimer()
```

### Checking timer status

Readonly properties:
``` Swift
self.timerView.secondsToEnd
self.timerView.secondsFromBeginning
self.timerView.isTimerStarted
self.timerView.isTimerFinished
self.timerView.isTimerPaused
self.timerView.progress
```

### Delegate
Adopt and implement the Delegate Protocol: ``` CountdownTimerDelegate ```
Set ``` self ``` as delegate
``` Swift
self.timerView.delegate = self
```
Implement delegate methods (all optional):
``` Swift
timerDidStart(sender: CountdownTimerView)
timerDidResume(sender: CountdownTimerView)
timerDidPause(sender: CountdownTimerView)
timerDidFinish(sender: CountdownTimerView)
timerDidReachTime(sender: CountdownTimerView, secondsToEnd: Int)
```

### Notifications
To handle notifications you need to set your ViewController as observer, eg:
``` Swift
NotificationCenter.default.addObserver(self, selector: #selector(someSelector), name: NSNotification.Name.TimerDidStart, object: nil)
```
List of notifications:
``` Swift
timerDidStart
timerDidResume
timerDidPause
timerDidFinish
```

# TO DO
<ul>
<li>Full configurable colors and steps when colors should be changed,</li>
<li>Adding new delegate method and notification after reach custom progress,</li>
<li>Adding repository to CocoaPods and Carthage,</li>
<li>More IBInspectable!</li>
</ul>

//
//  SimpleTimerViewController.swift
//  TodoList
//
//  Created by Student on 4/28/23.
//

import UIKit

// load the Simple Timer View
class SimpleTimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //outlets for our objects
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerPickerView: UIPickerView!
    
    //Timer value in seconds
    var timerValue: TimeInterval = 60
    //Countdown timer value
    var timerCountdownValue: TimeInterval = 0
    //instantiate variables used for timer UIpicker
    var timer: Timer?
    var hours = Array(0...23)
    var minutes = Array(0...59)
    
    //load the view
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the timer label to an empty string
        timerLabel.text = ""
        timerPickerView.dataSource = self
        timerPickerView.delegate = self
    }
    
    //fuunction for when the timer is started (when the 'start' button is tapped)
    @IBAction func startTimer(_ sender: Any) {
        if timer == nil {
            // Get the selected values from the timer picker view
            let selectedHours = timerPickerView.selectedRow(inComponent: 0)
            let selectedMinutes = timerPickerView.selectedRow(inComponent: 1)
            
            // Calculate the total number of seconds
            let totalSeconds = TimeInterval((selectedHours * 60 * 60) + (selectedMinutes * 60))
            
            // Update the timer label with the selected time
            let formattedTime = formatTimeInterval(totalSeconds)
            timerLabel.text = formattedTime
            
            // Hide the timer picker view and show the timer label
            timerPickerView.isHidden = true
            timerLabel.isHidden = false
            
            // Start the countdown timer
            timerCountdownValue = totalSeconds
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
            // Change the start button text to "Clear"
            startButton.setTitle("Clear", for: .normal)
        } else {
            // Reset the timer label and show the timer picker view
            timerLabel.text = "00:00:00"
            timerPickerView.isHidden = false
            timerLabel.isHidden = true
            
            // Stop and reset the countdown timer
            timer?.invalidate()
            timer = nil
            timerCountdownValue = 0
            
            // Change the start button text to "Start"
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    //function for formatting the time
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: interval)!
    }
    
    //function that pauses the timer when the pause button is tapped
    @IBAction func pauseTimer(_ sender: Any) {
        if timer != nil {
            //if the timer is not nil, check to see if the timer title is "Paused"
            if pauseButton.titleLabel?.text == "Pause" {
                //if it is, pause/invalidate the timer
                timer?.invalidate()
                //set the new title to "resume"
                pauseButton.setTitle("Resume", for: .normal)
            }else{
                //if the timer title hasnt been set, set it.
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                
                pauseButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    //updating the countdown on the timer
    @objc func updateTimer() {
        // Decrement the timerCountdownValue
        timerCountdownValue -= 1

        if timerCountdownValue <= 0 {
            // Reset timerCountdownValue and stop the timer
            timerCountdownValue = timerValue
            timer?.invalidate()
            timer = nil
            // Show the timer picker view and hide the timer label
            timerPickerView.isHidden = false
            timerLabel.isHidden = true
        } else {
            // Format the remaining time interval and update the timer label
            let formattedTime = formatTimeInterval(timerCountdownValue)
            timerLabel.text = formattedTime
        }
    }
        
    //functions needed to implement from the UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //the number of rows our components have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    //functions needed to be implemented from UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            //the titles for the component rows
            return "\(hours[row]) hours"
        } else {
            return "\(minutes[row]) minutes"
        }
    }
}

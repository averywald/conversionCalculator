//
//  ConverterViewController.swift
//  Conversion Calculator
//
//  Created by Avery Wald on 4/15/20.
//  Copyright © 2020 Avery Wald. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
	
	// MARK: - Properties
	
	// Interface Builder components
	@IBOutlet weak var inputDisplay: UITextField!
	@IBOutlet weak var outputDisplay: UITextField!
	@IBOutlet weak var clearButton: UIButton!
	@IBOutlet weak var posNegButton: UIButton!
	
	// default conversion setting
	var converter = Converter()

	// MARK: - Initializer
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.updateDisplay()
    }
    
	// MARK: - Methods
	
	@IBAction func recieveKeyboardInput(sender: AnyObject) {
		// grab input target button
		guard let button = sender as? UIButton else {
			return
		}
		
		// import user input as string
		let digitString = (button.titleLabel?.text)! as String
		
		// not decimal key pressed
		if digitString != "." {
			// check for data type conformity
			if let digit = Int(digitString) {
				// add Integer to input queue
				self.converter.accumulatorQueue.append(digit)
			}
			// clear button pressed
			if digitString == "C" {
				self.converter.clear()
				self.updateDisplay()
			}
			// +/- button pressed
			if digitString == "+/-" {
				self.converter.neg()
				self.updateDisplay()
			}
			// process input in Converter model
			self.converter.processInputQueue()
			// update UI to reflect changes
			self.updateDisplay()
		}
		else {
			self.converter.decimalize()
		}
		
	}
	
	// select converter button pressed
		// change to new conversion setting
	@IBAction func selectConversion(_ sender: Any) {
		// create action sheet
		let alert = UIAlertController(title: "Conversion Alert", message: "Select Conversion Formula", preferredStyle: UIAlertController.Style.alert)
		
		// add actions to action sheet
		alert.addAction(UIAlertAction(title: "Farenheit to Celcius", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in
			self.converter = Converter(alertAction.title!, "°F", "°C")
			self.updateDisplay()
			}))
		alert.addAction(UIAlertAction(title: "Celcius to Farenheit", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in
			self.converter = Converter(alertAction.title!, "°C", "°F")
			self.updateDisplay()
		}))
		alert.addAction(UIAlertAction(title: "Miles to Kilometers", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in
			self.converter = Converter(alertAction.title!, "MI", "KM")
			self.updateDisplay()
		}))
		alert.addAction(UIAlertAction(title: "Kilometers to Miles", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in
			self.converter = Converter(alertAction.title!, "KM", "MI")
			self.updateDisplay()
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
		
		// show action sheet
		self.present(alert, animated: true, completion: nil)
	}
	
	func updateDisplay() {
		let inStr = "\(String(self.converter.inputValue)) \(self.converter.inputUnit)"
		self.inputDisplay.text = inStr
		
		let outStr = "\(String(self.converter.outputValue)) \(self.converter.outputUnit)"
		self.outputDisplay.text = outStr
	}

}

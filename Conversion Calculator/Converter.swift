//
//  Converter.swift
//  Conversion Calculator
//
//  Created by Avery Wald on 4/17/20.
//  Copyright © 2020 Avery Wald. All rights reserved.
//

import Foundation

class Converter {
	
	// MARK: - Properties
	
	var label: String
	var inputUnit: String
	var outputUnit: String
	
	// hold recent input for decimalization
	var accumulatorQueue = [Int]()
	// hold input history for accurate decimal placing
	var totalQueue = [Int]()
	// holds input flattened into an operable number
	var inputValue: Float = 0.0
	// holds the converted input value
	var outputValue: Float = 0.0
	// tracks if the number should be positive / negative
	private var isNegative: Bool = false
	// mode for adding whole or decimal numbers
	private var isDecimal: Bool = false
	
	// MARK: - Initializers
	
	// default initializer
	init() {
		self.label = "Farenheit to Celcius"
		self.inputUnit = "°F"
		self.outputUnit = "°C"
	}
	// manual overloader
	init(_ l: String, _ i: String, _ o: String) {
		self.label = l
		self.inputUnit = i
		self.outputUnit = o
	}
	
	// MARK:  - Methods
	
	// reset all data but keep the same conversion mode
	func clear() {
		// clear numeric data
		self.accumulatorQueue = [Int]()
		self.totalQueue = [Int]()
		self.inputValue = 0.0
		self.outputValue = 0.0
		
		// reset state trackers
		self.isNegative = false
		self.isDecimal = false
	}
	
	// sets the output value
	func convert() {
		// take in input value
		switch self.label {
			case "Celcius to Farenheit":
				self.outputValue = (self.inputValue + 32) * (9/5)
			case "Miles to Kilometers":
				self.outputValue = self.inputValue * 1.609
			case "Kilometers to Miles":
				self.outputValue = self.inputValue / 1.609
			default:
				// farenheit to celcius
				self.outputValue = (self.inputValue - 32) * (5/9)
		}
	}
	
	// toggle input between whole and decimal
	func decimalize() {
		if self.isDecimal == false {
			// set to true
			self.isDecimal.toggle()
			// dump history
			self.totalQueue = self.accumulatorQueue
			// reset accumulator
			self.accumulatorQueue = [Int]()
		}

	}
	
	// toggle negativity
	func neg() {
		// toggle boolean
		self.isNegative.toggle()
	}
	
	// funnel input queue into correct decimal places
	func processInputQueue() {
		// temp container for sum(s)
		var sum: Float
		
		if self.isDecimal {
			// sum only digits after decimal button was pressed
			sum = self.processor(self.accumulatorQueue, true)
			// append to total sum
			self.inputValue += sum
		}
		else {
			// add all recent input digits to the history
			self.totalQueue = self.accumulatorQueue
			// sum digits
			sum = self.processor(self.totalQueue, false)
			// add to total input value
			self.inputValue = sum
		}
		
		// check for negativity
		if self.isNegative {
			self.inputValue.negate()
		}
		
		// execute conversion
		self.convert()
	}
	
	// helper function with processor business logic
	func processor(_ queue: [Int], _ decimalize: Bool) -> Float {
		// temporary summation container
		var sum: Float = 0.0
		
		// decimal button has been pressed
		if decimalize {
			// for each elem in NON-REVERSED queue
			for (index, elem) in queue.enumerated() {
				// first decimal place
				if index == 0 {
					sum = Float(elem) / 10
				}
				else {
					// variable of scoped-constant elem
					var temp = Float(elem)
					// shift decimal place right corresponding to elem's index
					for _ in 0...index {
						temp /= 10
					}
					// set as iteration's sum to be added to overall sum
					sum = temp
				}
			}
		}
		else {
			// reverse input history to match indices with powers
			let reversed = queue.reversed()
			
			// operate in order through input history
			for (index, elem) in reversed.enumerated() {
				// if only digit, no exponent needed
				if index == 0 {
					sum += Float(elem)
				}
				else {
					// temp var since elem is a constant in this scope
					var temp = Float(elem)
					// multiply by 10 ^ elem's index
					for _ in 0..<index {
						temp *= 10
					}
					// accumulate iteration into sum
					sum += temp
				}
			}
		}
		return sum
	}
	
}

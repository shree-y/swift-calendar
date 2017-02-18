//
//  ViewController.swift
//  Calculator
//
//  Created by Shree Yalamanchili on 1/21/17.
//  Copyright © 2017 Shree Yalamanchili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false

    // MARK: Actions
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            
            // If "." floating point already exists, do not add another "." floating point
            if (digit == ".") && (display.text!.range(of: ".") != nil) {
                return
            }
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        
    }
    
    
    
    // Clear the display and reset the accumulator
    @IBAction func clear(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        brain.resetOperand()
        displayValue = brain.result
    }
    
    
}


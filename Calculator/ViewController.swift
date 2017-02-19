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
    @IBOutlet private weak var status: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var previousButton = "";

    // MARK: Actions
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        previousButton = digit;
        
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
            status.text = brain.showStatus()
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

        let binaryOperations = ["+", "-", "÷", "*", "%"];
        
        // Return if user touches any combination of binary operation buttons continously without entering a digit
        if (binaryOperations.contains(previousButton) && binaryOperations.contains(sender.currentTitle!)) {
            return;
        }
        
        previousButton = sender.currentTitle!;
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        status.text = brain.showStatus()
        
    }
    
    
    
    // Clear the display and reset the accumulator
    @IBAction func clear(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        brain.resetOperand()
        displayValue = brain.result
    }
    
    
}


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
        }
        userIsInTheMiddleOfTyping = true
        
        if (brain.isPartialResult) {
            brain.description += " " + digit
        }
        else {
            brain.description += digit;
        }
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

        let binarySymbols = ["+", "-", "÷", "*", "%"];
        
        // Return if user touches any combination of binary operation buttons continously without entering a digit
        if (binarySymbols.contains(previousButton) && binarySymbols.contains(sender.currentTitle!)) {
            return;
        }
        
        previousButton = sender.currentTitle!;
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            updateStatusText(symbol: mathematicalSymbol);
        }
        displayValue = brain.result
        
    }
    
    private func updateStatusText(symbol: String) {
        let unarySymbols = ["±", "√", "cos"]

        if (brain.isPartialResult && brain.description != "") {
            status.text = brain.description + " ..."
        }
        else {
            status.text = brain.description + " ="
            
            // If there is no pending operation and if user just did a unary operation, set description to empty
            if (unarySymbols.contains(symbol)) {
                brain.description = "";
            }
        }
    }
    
    
    
    // Clear the display and reset the accumulator
    @IBAction func clear(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        brain.reset()
        displayValue = brain.result
        status.text = brain.description
    }
    
    
}


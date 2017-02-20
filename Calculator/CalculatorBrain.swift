//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Shree Yalamanchili on 1/24/17.
//  Copyright © 2017 Shree Yalamanchili. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    
    private var accumulator = 0.0
    var description = "";
    var isPartialResult = false;
    
    
    func setOperand(operand: Double) {
        accumulator = operand
    }

    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            
            case .Equals:
                executePendingBinaryOperation()
            }
            
            updateDescription(symbol: symbol)
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
            isPartialResult = false
        }
        else {
            isPartialResult = true
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }

    private func updateDescription(symbol: String) {
        let unarySymbols = ["±", "√", "cos"]
        let binarySymbols = ["+", "-", "÷", "*", "%"];

        if (isPartialResult) {
            
            // On a pending operation, if a user touches unary operation, 
            // delete the last digit of description, append the symbol to the last digit
            // and add it back to the description
            if (description != "" && unarySymbols.contains(symbol)) {
                var lastDigit = String(description[description.index(before: description.endIndex)])
                lastDigit = symbol + "(" + lastDigit + ")"
                description.remove(at: description.index(before: description.endIndex))
                description += lastDigit
                return;
            }
            // else add the symbol the the existing description
            description += " " + symbol
            
        }
        else {
            if (symbol != "=") {
                // Case where user performs a binary operation followed by unary operation
                // 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
                if (description != "" && unarySymbols.contains(symbol)) {
                    description = symbol + "(" + description + ")"
                }
                // Case where user performs two binary operations back to back
                
                else {
                    // For same symbols, there are no parenthesis
                    // 7 + 9 = + 6 + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
                    if (description.contains(symbol)) {
                        description = description + " " + symbol + " ";
                    }
                    else {
                        description = "(" + description + ") " + symbol + " ";
                    }
                }
            }
            else {
                // 7 + = 14 should be displayed as 7 + 7 = 14
                // If the description's last character is a symbol, and user pressed '=' then append accumulator to the description
                // Description last character
                if (description != "") {
                    let lastCharacter = String(description[description.index(before: description.endIndex)])
                    if (binarySymbols.contains(lastCharacter)) {
                        let firstDigit = String(description[description.startIndex])
                        description = description + " " + firstDigit
                    }
                }
            }
        }

    }
    
    // Reset
    func reset() {
        accumulator = 0.0
        pending = nil
        description = ""
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}

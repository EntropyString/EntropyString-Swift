//
//  Bits.swift
//  EntropyString-iOS
//
//  Copyright © 2017 Knoxen. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright © 2017 Knoxen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import Foundation

public struct Bits {
  static let log2_10: Float = log2(10)
  
  public static func total(of numStrings: Entropy.Power, risk: Entropy.Power) -> Float {
    if numStrings < .ten05 {
      return total(of: powf(10, Float(numStrings.rawValue)), risk: risk)
    }
    else {
      return Float(2 * numStrings.rawValue + risk.rawValue) * log2_10 - 1
    }
  }
  
  public static func total(of numStrings: Float, risk: Entropy.Power) -> Float {
    let log2Risk = Float(risk.rawValue) * log2_10
    return total(of: numStrings, log2Risk: log2Risk)
  }
  
  public static func total(of numStrings: Float , risk: Float) -> Float {
    return total(of: numStrings, log2Risk: log2(risk))
  }

  private static func total(of numStrings: Float, log2Risk: Float) -> Float {
    guard 0 < numStrings else { return 0 }
    let N = numStrings < 10001 ? log2(Float(numStrings)) + log2(Float(numStrings-1)) : 2 * log2(Float(numStrings))
    return N + log2Risk - 1
  }

}

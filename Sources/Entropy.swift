//
//  Entropy.swift
//  EntropyString
//
//  Copyright © 2017 Knoxen. All rights reserved.
//
//  The MIT License (MIT)
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

// MARK: - Enums
/// Errors thrown by Random
public enum EntropyStringError: Error {
  case tooFewBytes
  case negativeEntropy
  case invalidCharCount
  case charsNotUnique
}

public struct Entropy {
  
  static let bitsPerByte: UInt8 = 8
  private static let log2_10: Float = log2(10)
  
  /// Powers of ten
  @available(*, deprecated, message: "Use 1.0eNN")
  public enum Power: UInt {
    case ten01 = 1,
    ten02, ten03, ten04, ten05, ten06, ten07, ten08, ten09, ten10, ten11,
    ten12, ten13, ten14, ten15, ten16, ten17, ten18, ten19, ten20, ten21,
    ten22, ten23, ten24, ten25, ten26, ten27, ten28, ten29, ten30
    
    static func <(lhs: Power, rhs: Power) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }

  // MARK: - Public API (Static)
  //
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items expressed as *10^power*
  /// - parameter risk: Accepted probability expressed as 1 in *10^risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  public static func bits(for numStrings: Float , risk: Float) -> Float {
    guard 0 < numStrings else { return 0 }
    let N = numStrings < 10001 ? log2(numStrings) + log2(numStrings-1) : 2 * log2(numStrings)
    return N + log2(risk) - 1
  }
  
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items
  /// - parameter risk: Accepted probability expressed as 1 in *10^risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  @available(*, deprecated, message: "Use bits:(Float,Float)")
  public static func bits(for numStrings: Float, risk: Power) -> Float {
    let log2Risk = Float(risk.rawValue) * log2_10
    return total(numStrings: numStrings, log2Risk: log2Risk)
  }
  
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items
  /// - parameter risk: Accepted probability expressed as 1 in *risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  @available(*, deprecated, message: "Use bits:(Float,Float)")
  public static func bits(for numStrings: Power, risk: Power) -> Float {
    if numStrings < .ten05 {
      return bits(for: powf(10, Float(numStrings.rawValue)), risk: risk)
    }
    else {
      return Float(2 * numStrings.rawValue + risk.rawValue) * log2_10 - 1
    }
  }
  
  // CxTBD Remove with deprecated methods
  private static func total(numStrings: Float, log2Risk: Float) -> Float {
    guard 0 < numStrings else { return 0 }
    let N = numStrings < 10001 ? log2(Float(numStrings)) + log2(Float(numStrings-1)) : 2 * log2(Float(numStrings))
    return N + log2Risk - 1
  }

}

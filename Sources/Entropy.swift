//
//  Entropy.swift
//  EntropyString
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

public struct Entropy {
  
  /// Powers of ten
  public enum Power: UInt {
    case ten01 =  1
    case ten02 =  2
    case ten03 =  3
    case ten04 =  4
    case ten05 =  5
    case ten06 =  6
    case ten07 =  7
    case ten08 =  8
    case ten09 =  9
    case ten10 = 10
    case ten11 = 11
    case ten12 = 12
    case ten13 = 13
    case ten14 = 14
    case ten15 = 15
    case ten16 = 16
    case ten17 = 17
    case ten18 = 18
    case ten19 = 19
    case ten20 = 20
    case ten21 = 21
    case ten22 = 22
    case ten23 = 23
    case ten24 = 24
    case ten25 = 25
    case ten26 = 26
    case ten27 = 27
    case ten28 = 28
    case ten29 = 29
    case ten30 = 30
    
    static func <(lhs: Power, rhs: Power) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
  
  // MARK: - Public API (Static)
  //
  /// Calculates bits of entropy
  ///
  /// - parameter total: Number of items in the universal set express as a `UInt`
  /// - parameter risk: Accepted probability expressed as 1 in *risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* generated items.
  public static func bits(for total: UInt, risk: Power) -> Float {
    let tPower = log10(Float(total))
    var N: Float
    if UInt(tPower) < Power.ten09.rawValue {
      N = log2(Float(total) * Float(total-1)) + (Float(risk.rawValue) * log2(10)) - 1
    }
    else {
      let n = 2 * tPower + Float(risk.rawValue)
      N = n * log2(10) - 1
    }
    return N
  }
  
  /// Calculates bits of entropy
  ///
  /// - parameter total: Number of items in the universal set expressed a power of ten
  /// - parameter risk: Accepted probability expressed as 1 in *risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* generated items.
  public static func bits(for total: Power, risk: Power) -> Float {
    let n = 2 * total.rawValue + risk.rawValue
    let N = Float(n) * log2(10) - 1
    return N
  }

}

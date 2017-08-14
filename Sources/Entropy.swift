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

public struct Entropy {
  
  static let bitsPerByte: UInt8 = 8
  private static let log2_10: Float = log2(10)
  
  public enum Tmp: UInt {
    case one = 1, two, three, four
  }
  
  /// Powers of ten
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
  public static func bits(for total: Float , risk: Float) -> Float {
    return Bits.total(of: total, risk: risk)
  }
  
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items
  /// - parameter risk: Accepted probability expressed as 1 in *10^risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  public static func bits(for total: Float, risk: Power) -> Float {
    return Bits.total(of: total, risk: risk)
  }
  
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items
  /// - parameter risk: Accepted probability expressed as 1 in *risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  public static func bits(for total: Power, risk: Power) -> Float {
    return Bits.total(of: total, risk: risk)
  }

  public static func string(of bits: Float) {
//    return RandomString.entropy(of: bits, using: Entropy.ch)
  }
  
}

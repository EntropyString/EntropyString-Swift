//
//  EntropyTests.swift
//  EntropyString
//
//  Created by Paul Rogers on 8/14/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import XCTest
@testable import EntropyString

class EntropyTests: XCTestCase {
  var powers: [Entropy.Power]!

  override func setUp() {
    super.setUp()
    powers = [.ten01, .ten02, .ten03, .ten04, .ten05, .ten06, .ten07, .ten08, .ten09, .ten10,
              .ten11, .ten12, .ten13, .ten14, .ten15, .ten16, .ten17, .ten18, .ten19, .ten10,
              .ten21, .ten22, .ten23, .ten24, .ten25, .ten26, .ten27, .ten28, .ten29, .ten30] as [Entropy.Power]

  }
  
  func testZeroEntropy() {
    entropyBits0(0, 0, 0)
    for power in powers {
      entropyBits0(0, power, 0)
    }
  }
  
  func testBitsFloatFloat() {
    entropyBits2(    10,   1000, 15.46)
    entropyBits2(    10,  10000, 18.78)
    entropyBits2(    10, 100000, 22.10)
    
    entropyBits2(   100,   1000, 22.24)
    entropyBits2(   100,  10000, 25.56)
    entropyBits2(   100, 100000, 28.88)
    
    entropyBits2(  1000,   1000, 28.90)
    entropyBits2(  1000,  10000, 32.22)
    entropyBits2(  1000, 100000, 35.54)
    
    entropyBits2( 10000,   1000, 35.54)
    entropyBits2( 10000,  10000, 38.86)
    entropyBits2( 10000, 100000, 42.18)
    
    entropyBits2(100000,   1000, 42.19)
    entropyBits2(100000,  10000, 45.51)
    entropyBits2(100000, 100000, 48.83)
  }
  
  func testBitsFloatPower() {
    entropyBits2(    10, .ten03, 15.46)
    entropyBits2(    10, .ten04, 18.78)
    entropyBits2(    10, .ten05, 22.10)
    
    entropyBits2(   100, .ten03, 22.24)
    entropyBits2(   100, .ten04, 25.56)
    entropyBits2(   100, .ten05, 28.88)
    
    entropyBits2(  1000, .ten03, 28.90)
    entropyBits2(  1000, .ten04, 32.22)
    entropyBits2(  1000, .ten05, 35.54)
    
    entropyBits2( 10000, .ten03, 35.54)
    entropyBits2( 10000, .ten04, 38.86)
    entropyBits2( 10000, .ten05, 42.18)
    
    entropyBits2(100000, .ten03, 42.19)
    entropyBits2(100000, .ten04, 45.51)
    entropyBits2(100000, .ten05, 48.83)
  }
  
  func testBitsPowerPower() {
    entropyBits2(.ten01, .ten03, 15.46)
    entropyBits2(.ten01, .ten04, 18.78)
    entropyBits2(.ten01, .ten05, 22.10)
    
    entropyBits2(.ten02, .ten03, 22.24)
    entropyBits2(.ten02, .ten04, 25.56)
    entropyBits2(.ten02, .ten05, 28.88)
    
    entropyBits2(.ten03, .ten03, 28.90)
    entropyBits2(.ten03, .ten04, 32.22)
    entropyBits2(.ten03, .ten05, 35.54)
    
    entropyBits2(.ten04, .ten03, 35.54)
    entropyBits2(.ten04, .ten04, 38.86)
    entropyBits2(.ten04, .ten05, 42.18)
    
    entropyBits2(.ten05, .ten03, 42.19)
    entropyBits2(.ten05, .ten04, 45.51)
    entropyBits2(.ten05, .ten05, 48.83)
    
    for total in powers {
      for risk in powers {
        _ = Entropy.bits(for: total, risk: risk)
      }
    }
  }
  
  func testPreshingTable() {
    // From table at http://preshing.com/20110504/hash-collision-probabilities/
    // 32-bit column
    entropyBits0(30084, .ten01, 32)
    entropyBits0( 9292, .ten02, 32)
    entropyBits0( 2932, .ten03, 32)
    entropyBits0(  927, .ten04, 32)
    entropyBits0(  294, .ten05, 32)
    entropyBits0(   93, .ten06, 32)
    entropyBits0(   30, .ten07, 32)
    entropyBits0(   10, .ten08, 32)
    
    // 64-bit column
    entropyBits0(1970000000, .ten01, 64)
    entropyBits0( 609000000, .ten02, 64)
    entropyBits0( 192000000, .ten03, 64)
    entropyBits0(  60700000, .ten04, 64)
    entropyBits0(  19200000, .ten05, 64)
    entropyBits0(   6070000, .ten06, 64)
    entropyBits0(   1920000, .ten07, 64)
    entropyBits0(    607401, .ten08, 64)
    entropyBits0(    192077, .ten09, 64)
    entropyBits0(     60704, .ten10, 64)
    entropyBits0(     19208, .ten11, 64)
    entropyBits0(      6074, .ten12, 64)
    entropyBits0(      1921, .ten13, 64)
    entropyBits0(       608, .ten14, 64)
    entropyBits0(       193, .ten15, 64)
    entropyBits0(        61, .ten16, 64)
    entropyBits0(        20, .ten17, 64)
    entropyBits0(         7, .ten18, 64)
    
    // 160-bit column, modified (over/under) and extended
    entropyBits0(.ten24, .ten01, 162)
    entropyBits0(.ten23, .ten01, 155)
    entropyBits0(.ten24, .ten02, 165)
    entropyBits0(.ten23, .ten02, 158)
    entropyBits0(.ten23, .ten03, 162)
    entropyBits0(.ten22, .ten03, 155)
    entropyBits0(.ten23, .ten04, 165)
    entropyBits0(.ten22, .ten04, 158)
    entropyBits0(.ten22, .ten05, 162)
    entropyBits0(.ten21, .ten05, 155)
    entropyBits0(.ten22, .ten06, 165)
    entropyBits0(.ten21, .ten06, 158)
    entropyBits0(.ten21, .ten07, 162)
    entropyBits0(.ten20, .ten07, 155)
    entropyBits0(.ten21, .ten08, 165)
    entropyBits0(.ten20, .ten08, 158)
    entropyBits0(.ten20, .ten09, 162)
    entropyBits0(.ten19, .ten09, 155)
    entropyBits0(.ten20, .ten10, 165)
    entropyBits0(.ten19, .ten10, 158)
    entropyBits0(.ten19, .ten11, 162)
    entropyBits0(.ten18, .ten11, 155)
    entropyBits0(.ten19, .ten12, 165)
    entropyBits0(.ten18, .ten12, 158)
    entropyBits0(.ten18, .ten13, 162)
    entropyBits0(.ten17, .ten13, 155)
    entropyBits0(.ten18, .ten14, 165)
    entropyBits0(.ten17, .ten14, 158)
    entropyBits0(.ten17, .ten15, 162)
    entropyBits0(.ten16, .ten15, 155)
    entropyBits0(.ten17, .ten16, 165)
    entropyBits0(.ten16, .ten16, 158)
    entropyBits0(.ten16, .ten17, 162)
    entropyBits0(.ten15, .ten17, 155)
    entropyBits0(.ten16, .ten18, 165)
    entropyBits0(.ten15, .ten18, 158)
    entropyBits0(.ten15, .ten19, 162)
    entropyBits0(.ten14, .ten19, 155)
    entropyBits0(.ten15, .ten20, 165)
    entropyBits0(.ten14, .ten20, 158)
    entropyBits0(.ten14, .ten21, 162)
    entropyBits0(.ten13, .ten21, 155)
    entropyBits0(.ten14, .ten22, 165)
    entropyBits0(.ten13, .ten22, 158)
    entropyBits0(.ten13, .ten23, 162)
    entropyBits0(.ten12, .ten23, 155)
    entropyBits0(.ten13, .ten24, 165)
    entropyBits0(.ten12, .ten24, 158)
    entropyBits0(.ten12, .ten25, 162)
    entropyBits0(.ten11, .ten25, 155)
    entropyBits0(.ten12, .ten26, 165)
    entropyBits0(.ten11, .ten26, 158)
    entropyBits0(.ten11, .ten27, 162)
    entropyBits0(.ten10, .ten27, 155)
    entropyBits0(.ten11, .ten28, 165)
    entropyBits0(.ten10, .ten28, 158)
    entropyBits0(.ten10, .ten29, 162)
    entropyBits0(.ten09, .ten29, 155)
    entropyBits0(.ten10, .ten30, 165)
    entropyBits0(.ten09, .ten30, 158)
  }



  func entropyBits0(_ numStrings: Float, _ risk: Float, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    XCTAssertEqual(roundf(bits), expected)
  }

  func entropyBits0(_ numStrings: Float, _ risk: Entropy.Power, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    XCTAssertEqual(roundf(bits), expected)
  }

  func entropyBits0(_ numStrings: Entropy.Power, _ risk: Entropy.Power, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    XCTAssertEqual(roundf(bits), expected)
  }

  func checkEqual2(_ num: Float, _ expected: Float) {
    XCTAssertEqual(roundf(num * 100)/100, expected)
  }
  
  func entropyBits2(_ numStrings: Float, _ risk: Float, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    checkEqual2(bits, expected)
  }

  func entropyBits2(_ numStrings: Float, _ risk: Entropy.Power, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    checkEqual2(bits, expected)
  }
  
  func entropyBits2(_ numStrings: Entropy.Power, _ risk: Entropy.Power, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    checkEqual2(bits, expected)
  }
}

extension EntropyTests {
  // Adopt XCTestCaseProvider to run test on  Linux
//  static var allTests: [(String, (EntropyTests) -> () throws -> ()] {
//  return [
//    ("testZeroEntropy",         EntropyTests.testZeroEntropy)
//  
//  ]}
}

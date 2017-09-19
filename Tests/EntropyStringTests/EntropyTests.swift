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
  
  func testZeroEntropy() {
    entropyBits_r0(0, 0, 0)
  }
  
  func testBitsIntInt() {
    entropyBits_r2(    10,   1000, 15.46)
    entropyBits_r2(    10,  10000, 18.78)
    entropyBits_r2(    10, 100000, 22.10)
    
    entropyBits_r2(   100,   1000, 22.24)
    entropyBits_r2(   100,  10000, 25.56)
    entropyBits_r2(   100, 100000, 28.88)
    
    entropyBits_r2(  1000,   1000, 28.90)
    entropyBits_r2(  1000,  10000, 32.22)
    entropyBits_r2(  1000, 100000, 35.54)
    
    entropyBits_r2( 10000,   1000, 35.54)
    entropyBits_r2( 10000,  10000, 38.86)
    entropyBits_r2( 10000, 100000, 42.18)
    
    entropyBits_r2(100000,   1000, 42.19)
    entropyBits_r2(100000,  10000, 45.51)
    entropyBits_r2(100000, 100000, 48.83)
  }
  
  func testBitsIntFloat() {
    entropyBits_r2(    10, 1.0e03, 15.46)
    entropyBits_r2(    10, 1.0e04, 18.78)
    entropyBits_r2(    10, 1.0e05, 22.10)
    
    entropyBits_r2(   100, 1.0e03, 22.24)
    entropyBits_r2(   100, 1.0e04, 25.56)
    entropyBits_r2(   100, 1.0e05, 28.88)
    
    entropyBits_r2(  1000, 1.0e03, 28.90)
    entropyBits_r2(  1000, 1.0e04, 32.22)
    entropyBits_r2(  1000, 1.0e05, 35.54)
    
    entropyBits_r2( 10000, 1.0e03, 35.54)
    entropyBits_r2( 10000, 1.0e04, 38.86)
    entropyBits_r2( 10000, 1.0e05, 42.18)
    
    entropyBits_r2(100000, 1.0e03, 42.19)
    entropyBits_r2(100000, 1.0e04, 45.51)
    entropyBits_r2(100000, 1.0e05, 48.83)
  }
  
  func testBitsFloatFloat() {
    entropyBits_r2(1.0e01, 1.0e03, 15.46)
    entropyBits_r2(1.0e01, 1.0e04, 18.78)
    entropyBits_r2(1.0e01, 1.0e05, 22.10)
    
    entropyBits_r2(1.0e02, 1.0e03, 22.24)
    entropyBits_r2(1.0e02, 1.0e04, 25.56)
    entropyBits_r2(1.0e02, 1.0e05, 28.88)
    
    entropyBits_r2(1.0e03, 1.0e03, 28.90)
    entropyBits_r2(1.0e03, 1.0e04, 32.22)
    entropyBits_r2(1.0e03, 1.0e05, 35.54)
    
    entropyBits_r2(1.0e04, 1.0e03, 35.54)
    entropyBits_r2(1.0e04, 1.0e04, 38.86)
    entropyBits_r2(1.0e04, 1.0e05, 42.18)
    
    entropyBits_r2(1.0e05, 1.0e03, 42.19)
    entropyBits_r2(1.0e05, 1.0e04, 45.51)
    entropyBits_r2(1.0e05, 1.0e05, 48.83)
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


  }

  func entropyBits_r0(_ numStrings: Float, _ risk: Float, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    XCTAssertEqual(roundf(bits), expected)
  }

  func entropyBits_r2(_ numStrings: Float, _ risk: Float, _ expected: Float) {
    let bits = Entropy.bits(for: numStrings, risk: risk)
    XCTAssertEqual(roundf(bits * 100)/100, expected)
  }
}

extension EntropyTests {
// Adopt XCTestCaseProvider to run test on  Linux
  static var tests: [(String, (EntropyTests) -> () throws -> ())] {
    return [
      ("testZeroEntropy",    testZeroEntropy),
      ("testBitsIntInt",     testBitsIntInt),
      ("testBitsIntFloat",   testBitsIntFloat),
      ("testBitsFloatFloat", testBitsFloatFloat),
      ("testPreshingTable",  testPreshingTable)
    ]
  }
}

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
    entropyBits_r0(30084, 1.0e01, 32)
    entropyBits_r0( 9292, 1.0e02, 32)
    entropyBits_r0( 2932, 1.0e03, 32)
    entropyBits_r0(  927, 1.0e04, 32)
    entropyBits_r0(  294, 1.0e05, 32)
    entropyBits_r0(   93, 1.0e06, 32)
    entropyBits_r0(   30, 1.0e07, 32)
    entropyBits_r0(   10, 1.0e08, 32)

    // 64-bit column
    entropyBits_r0( 1.97e09, 1.0e01, 64)
    entropyBits_r0( 6.09e08, 1.0e02, 64)
    entropyBits_r0( 1.92e08, 1.0e03, 64)
    entropyBits_r0( 6.07e07, 1.0e04, 64)
    entropyBits_r0( 1.92e07, 1.0e05, 64)
    entropyBits_r0( 6.07e06, 1.0e06, 64)
    entropyBits_r0( 1.92e06, 1.0e07, 64)
    entropyBits_r0(  607401, 1.0e08, 64)
    entropyBits_r0(  192077, 1.0e09, 64)
    entropyBits_r0(   60704, 1.0e10, 64)
    entropyBits_r0(   19208, 1.0e11, 64)
    entropyBits_r0(    6074, 1.0e12, 64)
    entropyBits_r0(    1921, 1.0e13, 64)
    entropyBits_r0(     608, 1.0e14, 64)
    entropyBits_r0(     193, 1.0e15, 64)
    entropyBits_r0(      61, 1.0e16, 64)
    entropyBits_r0(      20, 1.0e17, 64)
    entropyBits_r0(       7, 1.0e18, 64)

    // 160-bit column
    entropyBits_r0(1.42e24,      2, 160)
    entropyBits_r0(5.55e23,     10, 160)
    entropyBits_r0(1.71e23,    100, 160)
    entropyBits_r0(5.41e22,   1000, 160)
    entropyBits_r0(1.71e22, 1.0e04, 160)
    entropyBits_r0(5.41e21, 1.0e05, 160)
    entropyBits_r0(1.71e21, 1.0e06, 160)
    entropyBits_r0(5.41e20, 1.0e07, 160)
    entropyBits_r0(1.71e20, 1.0e08, 160)
    entropyBits_r0(5.41e19, 1.0e09, 160)
    entropyBits_r0(1.71e19, 1.0e10, 160)
    entropyBits_r0(5.41e18, 1.0e11, 160)
    entropyBits_r0(1.71e18, 1.0e12, 160)
    entropyBits_r0(5.41e17, 1.0e13, 160)
    entropyBits_r0(1.71e17, 1.0e14, 160)
    entropyBits_r0(5.41e16, 1.0e15, 160)
    entropyBits_r0(1.71e16, 1.0e16, 160)
    entropyBits_r0(5.41e15, 1.0e17, 160)
    entropyBits_r0(1.71e15, 1.0e18, 160)
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

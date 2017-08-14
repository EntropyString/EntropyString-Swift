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
    
  func testBits() {
    check(Entropy.bits(for: 1000,   risk: 1000000), expected: 38.86)
    check(Entropy.bits(for: 10000,  risk: 1000000), expected: 45.51)
    check(Entropy.bits(for: 100000, risk: 1000000), expected: 52.15)
  }
  
  func check(_ num: Float, expected: Float) {
    XCTAssertEqual(roundf(num * 100)/100, expected)
  }
}

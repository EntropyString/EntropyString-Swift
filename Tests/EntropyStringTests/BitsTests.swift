//
//  BitsTests.swift
//  EntropyString
//
//  Created by Paul Rogers on 8/11/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import XCTest
@testable import EntropyString

class BitsTests: XCTestCase {
    
  func testBits() {
    check(Bits.total(of: 1000,   risk: 1000000), expected: 38.86)
    check(Bits.total(of: 10000,  risk: 1000000), expected: 45.51)
    check(Bits.total(of: 100000, risk: 1000000), expected: 52.15)

    
  }
  
  func check(_ num: Float, expected: Float) {
    XCTAssertEqual(roundf(num * 100)/100, expected)
  }
}

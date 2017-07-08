//: [Previous](@previous)
//:## Basic Usage

import EntropyString

//: Calculate bits of entropy to cover **1 million strings** with a repeat *risk* of 
//: **1 in a billion** and generate a string using a set of 32 characters:
let bits = Entropy.bits(for: .ten06, risk: .ten09)
var string = RandomString.entropy(of: bits, using: .charSet32)
print(string)
//: * callout(string): 9Pp7MDDm7b9Dhb
//:
//: Generate a string of the same entropy using set of 16 characters (hexadecimal)
string = RandomString.entropy(of: bits, using: .charSet16)
print(string)
//: * callout(string): d33fa62f572c4cc9c8
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)

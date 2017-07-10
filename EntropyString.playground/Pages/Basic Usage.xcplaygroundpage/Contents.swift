//: [Previous](@previous)
//:## Basic Usage
//: Calculate the bits of entropy necessary to cover a *risk* of a **1 in a billion** chance
//: of a repeat in a *total* of **1 million** strings and generate a example string using a
//: set of 32 characters:
import EntropyString

let bits = Entropy.bits(for: .ten06, risk: .ten09)
var string = RandomString.entropy(of: bits, using: .charSet32)
print(string)
//: * callout(string): 9Pp7MDDm7b9Dhb
//:
//: Generate a string of the same entropy using set of 16 characters (hexadecimal):
string = RandomString.entropy(of: bits, using: .charSet16)
print(string)
//: * callout(string): d33fa62f572c4cc9c8
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)

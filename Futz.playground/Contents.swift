//: Playground - noun: a place where people can play

import EntropyString

Entropy.bits(for: 100000, risk: 1000000)

var random = Random(charSet: .charSet64)
random.sessionID()

random = Random(charSet: .charSet16)
random.sessionID()



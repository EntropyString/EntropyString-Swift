//: [Previous](@previous)
//: ## TLDR 2
//: ### Take Away
//:
//:  - You don't need random strings of length L.
//:    - String length is a by-product, not a goal.
//:  - You need unique strings.
//:    - Uniqueness is too onerous. You'll do fine with probabilistically unique strings.
//:  - Probabilistic uniqueness involves measured risk.
//:    - Risk is measured as *"1 in __n__ chance of generating a repeat"*
//:    - Bits of entropy gives you that measure.
//:  - You need to a total of **_N_** strings with a risk **_1/n_** of repeat.
//:    - The characters are arbitrary.
//:  - You need `EntropyString`.
import EntropyString

let N: Entropy.Power = .ten06
let n: Entropy.Power = .ten09
var bits = Entropy.bits(for: N, risk: n)
let string = RandomString.entropy(of: bits, using: .charSet32)
//: * callout(string): DdHrT2NdrHf8tM


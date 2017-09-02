//: [Previous](@previous)
//: ## TLDR 2
//: ### Take Away
//:  - You don't need random strings of length L.
//:    - String length is a by-product, not a goal.
//:  - You don't need truly unique strings.
//:    - Uniqueness is too onerous. You'll do fine with probabilistically unique strings.
//:  - Probabilistic uniqueness involves measured risk.
//:    - Risk is measured as *"1 in __n__ chance of generating a repeat"*
//:    - Bits of entropy gives you that measure.
//:  - You need to a total of **_N_** strings with a risk **_1/n_** of repeat.
//:    - The characters are arbitrary.
//:  - You need `EntropyString`.
//: ##### Base 32 character string with a 1 in a million chance of a repeat a billion strings:
  import EntropyString

  let random = Random()
  let bits = Entropy.bits(for: 1.0e6, risk: 1.0e9)
  let string = random.string(bits: bits)

  print("String: \(string)\n")
//: * callout(string): DdHrT2NdrHf8tM
//:
//: [TOC](Table%20of%20Contents)


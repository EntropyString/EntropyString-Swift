//: [Previous](@previous)
//: ## Secure Bytes
//:
//: As described in [Efficiency](Efficiency), `EntropyString` uses an underlying array of bytes to generate strings. The entropy of the resulting strings is, of course, directly related to the randomness of the bytes used. That's an important point. Strings are only capable of carrying information (entropy); random bytes actually provide the entropy itself.
//:
//: `EntropyString` automatically generates the necessary number of bytes needed to create a  random string. On Apple OSes, `EntropyString` uses either `SecRandomCopyBytes` or `arc4random_buf`, both of which are cryptographically secure random number generators. `SecRandomCopyBytes` is the stronger of the two, but can fail if the system entropy pool lacks sufficient randomness. Rather than propagate that failure, if `SecRandomCopyBytes` fails, `EntropyString` falls back and uses `arc4random_buf` to generate the bytes. Though  not as strong, `arc4random_buf` does not fail.
//:
//: You may, of course, want feedback as to when or if `SecRandomCopyBytes` fails. `RandomString.entropy(of:using:secRand)` provides an additional `inout` parameter that acts as  a flag should a `SecRandomCopyBtyes` call fail.
//:
//: On Linux, `EntropyString` always uses `arc4random_buf`. The `secRand` parameter is ignored.
//:
import EntropyString

let random = Random()
var secRand = true
random.string(bits: 20, secRand: &secRand)
  
print("secRand: \(secRand)")
//: * callout(secRand): true
//:
//: If `SecRandomCopyBytes` is used, the __secRand__ parameter will remain `true`; otherwise it will be set to `false`.
//:
//: You can also pass in __secRand__ as `false`, in which case the `entropy` call will not attempt to use `SecRandomCopyBytes` and will use `arc4random_buf`.
secRand = false
random.string(bits: 20, secRand: &secRand)
//:
//: Rather than have `EntropyString` generate bytes automatically, you can provide your own [Custom Bytes](Custom%20Bytes) to create a string, which is the next topic.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)

//: [Previous](@previous)
//:
//: ## Overview
//:
//: `EntropyString` provides easy creation of randomly generated strings of specific entropy using various character sets. Such strings are needed as unique identifiers when generating, for example, random IDs and you don't want the overkill of a GUID.
//:
//: A key concern when generating such strings is that they be unique. Guaranteed uniqueness, however,, requires either deterministic generation (e.g., a counter) that is not random, or that each newly created random string be compared against all existing strings. When ramdoness is required, the overhead of storing and comparing strings is often too onerous and a different tack is chosen.
//:
//: A common strategy is to replace the *guarantee of uniqueness* with a weaker but often sufficient *probabilistic uniqueness*. Specifically, rather than being absolutely sure of uniqueness, we settle for a statement such as *"there is less than a 1 in a billion chance that two of my strings are the same"*. This strategy requires much less overhead, but does require we have some manner of qualifying what we mean by *"there is less than a 1 in a billion chance that 1 million strings of this form will have a repeat"*.
//:
//: Understanding probabilistic uniqueness of random strings requires an understanding of [*entropy*](https://en.wikipedia.org/wiki/Entropy_(information_theory)) and of estimating the probability of a [*collision*](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem) (i.e., the probability that two strings in a set of randomly generated strings might be the same). The blog posting [Hash Collision Probabilities](http://preshing.com/20110504/hash-collision-probabilities/) provides an excellent overview of deriving an expression for calculating the probability of a collision in some number of hashes using a perfect hash with an N-bit output. The [Entropy Bits](EntropyBits) section discribes how `EntropyString` takes this idea a step further to address a common need in generating unique identifiers.
//:
//:We'll begin investigating `EntropyString` and this common need by considering our [Real Need](#Real%20Need) when generating random strings.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)

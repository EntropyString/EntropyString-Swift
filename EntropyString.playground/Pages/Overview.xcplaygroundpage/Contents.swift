//: [Previous](@previous)
//:
//: ## Overview
//:
//: `EntropyString` provides easy creation of randomly generated strings of specific entropy using various character sets. Such strings are needed when generating, for example, random IDs and you don't want the overkill of a GUID, or for ensuring that some number of items have unique identifiers.
//:
//: A key concern when generating such strings is that they be unique. To truly guarantee uniqueness requires either deterministic generation (e.g., a counter) that is not random, or that each newly created random string be compared against all existing strings. When ramdoness is required, the overhead of storing and comparing strings is often too onerous and a different tack is needed.
//:
//: A common strategy is to replace the *guarantee of uniqueness* with a weaker but often sufficient *probabilistic uniqueness*. Specifically, rather than being absolutely sure of uniqueness, we settle for a statement such as *"there is less than a 1 in a billion chance that two of my strings are the same"*. This strategy requires much less overhead, but does require we have some manner of qualifying what we mean by, for example, *"there is less than a 1 in a billion chance that 1 million strings of this form will have a repeat"*.
//:
//: Understanding probabilistic uniqueness requires some understanding of [*entropy*](https://en.wikipedia.org/wiki/Entropy_(information_theory)) and of estimating the probability of a [*collision*](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem) (i.e., the probability that two strings in a set of randomly generated strings might be the same).  Happily, you can use `entropy-string` without a deep understanding of these topics.
//:
//: We'll begin investigating `EntropyString` by considering our [Real Need](Read%20Need) when generating random strings.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)

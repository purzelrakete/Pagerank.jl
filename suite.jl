require("Pagerank")
using Pagerank

tests = [
  "test/io.jl",
  "test/rank.jl",
  "test/dangling.jl"
]

println("Running suite.")

for test in tests
  println(" * $(test)")
  include(test)
end


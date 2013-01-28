require("Pagerank")
using Pagerank

tests = [
  "test/rank.jl",
  "test/io.jl",
  "test/dangling.jl"
]

println("Running suite.")

for test in tests
  println(" * $(test)")
  include(test)
end


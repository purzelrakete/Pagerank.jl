require("Pagerank")
using Pagerank

run(`test/bin/setup`)

tests = [
  "test/io/fast.jl",
  "test/io/dangling.jl",
  "test/rank/dangling.jl",
  "test/rank/gaps.jl",
  "test/rank/simple.jl"
]

println("Running suite.")

for test in tests
  println(" * $(test)")
  include(test)
end

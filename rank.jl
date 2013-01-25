require("Pagerank")
using Pagerank

alpha = 0.85
iterations = 100
edgelist = ARGS[1]

rank = Rank(alpha, iterations, edgelist)
names, actual = stationary_distribution(rank)

println(actual)


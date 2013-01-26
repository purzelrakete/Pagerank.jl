require("Pagerank")
using Pagerank

alpha = 0.85
accuracy = 0.00001
edgelist = ARGS[1]

rank = Rank(alpha, accuracy, edgelist)
names, actual = stationary_distribution(rank)

println(actual)


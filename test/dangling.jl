alpha = 0.85
iterations = 100
edgelist = "test/data/dangling.tsv"

rank = Rank(alpha, iterations, edgelist)
names, actual = stationary_distribution(rank)
count = size(actual)[2]

# expected rank is  4, 3, 2, 5, 6, 1,
expected = [0.037376, 0.208177, 0.245340, 0.245340, 0.176409, 0.087354]
precision = 5

for i in 1:count
  println(@sprintf("%s	%s", names[i], actual[i]))
end

@assert isequal(floor(expected, precision), floor(actual, precision))


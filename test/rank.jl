alpha = 0.5
iterations = 20
edgelist = "test/data/test.tsv"

rank = Rank(alpha, iterations, edgelist)
names, actual = stationary_distribution(rank)
count = size(actual)[2]

expected = [float(5 / 18) float(4 / 9) float(5 / 18)]
precision = 5

@assert isequal(floor(expected, precision), floor(actual, precision))


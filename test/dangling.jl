alpha = 0.85
accuracy = 0.00001
edgelist = "test/data/dangling.tsv"

rank = Rank(alpha, accuracy, edgelist)
names, actual = stationary_distribution(rank)
count = size(actual)[2]

# expected rank is  4, 3, 2, 5, 6, 1,
expected = [0.037375 0.208173 0.245344 0.245344 0.176404 0.087356]
precision = 5

@assert isequal(floor(expected, precision), floor(actual, precision))


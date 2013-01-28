alpha = 0.85
accuracy = 0.00001
edgelist = "test/data/dangling.tsv"

rank = Rank(alpha, accuracy, edgelist)
r, origin_idx = stationary_distribution(rank)
count = length(r)

# expected rank is  4, 3, 2, 5, 6, 1,
expected = [0.037375 0.208173 0.245344 0.245344 0.176404 0.087356]
projected_idx = map(x -> x[2], sort(reverse(pairs(origin_idx))))
precision = 5

@assert isequal(floor(expected[projected_idx], precision), floor(r, precision))


alpha = 0.5
accuracy = 0.0000001
edgelist = "test/data/test.tsv"

rank = Rank(alpha, accuracy, edgelist)
r, origin_idx = stationary_distribution(rank)
count = length(r)

expected = [float(5 / 18) float(4 / 9) float(5 / 18)]
projected_idx = map(x -> x[2], sort(reverse(pairs(origin_idx))))
precision = 5

@assert isequal(floor(expected[projected_idx], precision), floor(r, precision))


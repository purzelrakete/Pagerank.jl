alpha = 0.85
accuracy = 0.00001
edgelist = "test/fixtures/dangling.adj"

rank = Rank{Float64,Int64}(alpha, accuracy, edgelist)
r = stationary_distribution(rank)
count = length(r)

# expected rank is  4, 3, 2, 5, 6, 1,
expected = [0.037375, 0.208173, 0.245344, 0.245344, 0.176404, 0.087356]
precision = 5

@assert isequal(floor(expected, precision), floor(r, precision))


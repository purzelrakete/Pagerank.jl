alpha = 0.5
iterations = 100
edgelist = "test/data/test.tsv"

rank = Rank(alpha, iterations, edgelist)
names, p = stationary_distribution(rank)
count = size(p)[2]

actual = p
expected = [float(5 / 18) float(4 / 9) float(5 / 18)]
precision = 5

for i in 1:count
  println(@sprintf("%s	%s", names[i], p[i]))
end

@assert isequal(floor(expected, precision), floor(actual, precision))


alpha = 0.85
edgelist = "test/data/dangling.tsv"
order = 6

actual = pagerank_matrix(order, edgelist, alpha)
expected = sparse([
 0.0  0.85     0.0      0.0      0.0      0.0
 0.0  0.0      0.425    0.425    0.0      0.0
 0.0  0.28333  0.0      0.28333  0.28333  0.0
 0.0  0.28333  0.28333  0.0      0.28333  0.0
 0.0  0.0      0.28333  0.28333  0.0      0.28333
 0.0  0.0      0.0      0.0      0.0      0.0
])

difference = (max(dense(expected) - dense(actual)))
@assert isequal(0, difference)


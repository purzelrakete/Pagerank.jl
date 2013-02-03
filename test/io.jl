alpha = 0.85
edgelist = "test/data/dangling.tsv"
order = 6

M, origin_idx, absorbing, size = pagerank_matrix(Float64, Int64, alpha, edgelist)

expected = sparse([
 0.0  0.85     0.0      0.0      0.0      0.0
 0.0  0.0      0.425    0.425    0.0      0.0
 0.0  0.28333  0.0      0.28333  0.28333  0.0
 0.0  0.28333  0.28333  0.0      0.28333  0.0
 0.0  0.0      0.28333  0.28333  0.0      0.28333
 0.0  0.0      0.0      0.0      0.0      0.0
])

difference = (max(dense(expected) - dense(M)))
@assert isequal(0, difference)
@assert isequal([6], absorbing)


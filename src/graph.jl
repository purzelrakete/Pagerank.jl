# FIXME highly inefficient. does not stay sparse over bsxfun
function pagerank_matrix(graph::DirectedGraph, size, alpha)
  A::SparseMatrixCSC{Float64, Int64} = spzeros(size, size)
  origin_idx = Dict{Int32,Int32}(size)

  for edge in edges(graph)
    A[id(out(edge)), id(in(edge))] = 1
  end

  for vertex in vertices(graph)
    origin_idx[int32(id(vertex))] = int32(label(vertex))
  end

  totals = sum(A, 2)
  absorbing = find(x -> x == 0, totals)
  totals[absorbing] = 1
  M = sparse(alpha * bsxfun(./, A, totals))

  return M, origin_idx, absorbing
end


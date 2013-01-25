type Rank
  alpha::Float64
  iters::Integer
  graph::DirectedGraph
  size::Integer
  prior::Array{Float64}

  function Rank(alpha::Float64, iters::Integer, edgelist::String)
    Rank(alpha, iters, Graphs.read_edgelist(edgelist))
  end

  function Rank(alpha::Float64, iters::Integer, graph::DirectedGraph)
    size = order(graph)
    uniform = ones(1, size) / size
    new(alpha, iters, graph, size, uniform)
  end
end

function stationary_distribution(rank::Rank)
  M::SparseMatrixCSC{Float64, Int64} = spzeros(rank.size, rank.size)
  names = Dict{Integer,Vertex}(rank.size)

  println("> building adjacency matrix for $(rank.size) vertices")

  for edge in edges(rank.graph)
    M[id(out(edge)), id(in(edge))] = 1
  end

  for vertex in vertices(rank.graph)
    names[id(vertex)] = vertex
  end

  println("> normalize and dampen")

  totals = sum(M, 2)
  absorbing = find(x -> x == 0, totals)
  totals[absorbing] = 1
  N = rank.alpha * bsxfun(./, M, totals)

  println("> iterating")

  r::Array{Float64} = zeros(1, rank.size)
  r[1] = 1

  for i in 1:rank.iters
    reabsorption = sum(r[absorbing]) * rank.alpha / rank.size
    r = r * N + ((1 - rank.alpha) / rank.size) + reabsorption
  end

  return names, r
end


type Rank
  alpha::Float64
  accuracy::Float64
  graph::DirectedGraph
  size::Integer
  prior::Array{Float64}

  function Rank(alpha::Float64, accuracy::Float64, edgelist::String)
    Rank(alpha, accuracy, Graphs.read_edgelist(edgelist))
  end

  function Rank(alpha::Float64, accuracy::Float64, graph::DirectedGraph)
    size = order(graph)
    uniform = ones(1, size) / size
    new(alpha, accuracy, graph, size, uniform)
  end
end

size(rank::Rank) = rank.size

function stationary_distribution(rank::Rank)
  A::SparseMatrixCSC{Float64, Int64} = spzeros(rank.size, rank.size)
  names = Dict{Integer,Vertex}(rank.size)

  println("> building adjacency matrix for $(rank.size) vertices")

  for edge in edges(rank.graph)
    A[id(out(edge)), id(in(edge))] = 1
  end

  for vertex in vertices(rank.graph)
    names[id(vertex)] = vertex
  end

  println("> normalize and dampen")

  totals = sum(A, 2)
  absorbing = find(x -> x == 0, totals)
  totals[absorbing] = 1
  M = rank.alpha * bsxfun(./, A, totals)

  println("> iterating")

  r::Array{Float64} = zeros(1, rank.size)
  last::Array{Float64} = zeros(1, rank.size)
  r[1] = 1

  i = 0
  while max(abs(r - last)) > rank.accuracy
    println("> $(i)")
    i += 1
    last = r
    reabsorption = sum(r[absorbing]) * rank.alpha / rank.size
    r = r * M + ((1 - rank.alpha) / rank.size) + reabsorption
  end

  return names, r
end


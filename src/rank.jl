type Rank
  alpha::Float64
  accuracy::Float64
  size::Integer
  absorbing::Array{Int32}
  M::SparseMatrixCSC{Float64, Int64}
  origin_idx::Dict{Int32,Int32}
  prior::Array{Float64}

  function Rank(alpha::Float64, accuracy::Float64, edges::String)
    M, origin_idx, absorbing, size = pagerank_matrix(alpha, edges)
    new(alpha, accuracy, size, absorbing, M, origin_idx, ones(1, size) / size)
  end
end

size(rank::Rank) = rank.size

function stationary_distribution(rank)
  r::Array{Float64, 1} = zeros(rank.size)
  last::Array{Float64, 1} = zeros(rank.size)
  r[1] = 1

  i = 0
  while max(abs(r - last)) > rank.accuracy
    i += 1
    last = r
    reabsorption = sum(r[rank.absorbing]) * rank.alpha / rank.size
    r = r * rank.M  + ((1 - rank.alpha) / rank.size) + reabsorption
    @show i
  end

  return r, rank.origin_idx
end


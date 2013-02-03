# Tv: sparse matrix value type
# Ti: sparse matrix id space
type Rank{Tv<:Real,Ti<:Integer}
  alpha::Float64
  accuracy::Float64
  size::Integer
  absorbing::Array{Tv}
  M::SparseMatrixCSC{Tv,Ti}
  origin_idx::Dict{Ti,Ti}
  prior::Array{Tv}

  function Rank(alpha::Float64, accuracy::Float64, edges::String)
    M, origin_idx, absorbing, size = pagerank_matrix(Tv,Ti, alpha, edges)
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


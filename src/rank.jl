# Tv: sparse matrix value type
# Ti: sparse matrix id space
type Rank{Tv<:Real,Ti<:Integer}
  alpha::Float64
  accuracy::Float64
  order::Ti
  max::Ti
  absorbing::Array{Ti}
  M::SparseMatrixCSC{Tv,Ti}
  prior::Array{Tv}

  function Rank(alpha::Float64, accuracy::Float64, edges::String)
    M, absorbing, order, max = pagerank_matrix(Tv,Ti, alpha, edges)
    new(alpha, accuracy, order, max, absorbing, M, ones(1, order) / order)
  end
end

function stationary_distribution(rank)
  r::Array{Float64, 1} = zeros(rank.max)
  last::Array{Float64, 1} = zeros(rank.max)
  r[1] = 1

  i = 0
  while max(abs(r - last)) > rank.accuracy
    i += 1
    last = r

    reabsorption = sum(r[rank.absorbing]) * rank.alpha / rank.order
    r = r * rank.M
    r += ((1 - rank.alpha) / rank.order) + reabsorption
    @show i
  end

  return r
end


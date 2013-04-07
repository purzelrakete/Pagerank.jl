# Tv: sparse matrix value type
# Ti: sparse matrix id space
type Rank{Tv<:Real,Ti<:Integer}
  alpha::Float64
  accuracy::Float64
  order::Ti
  absorbing::Array{Ti}
  M::SparseMatrixCSC{Tv,Ti}
  prior::Array{Tv}

  function Rank(alpha::Float64, accuracy::Float64, edges::String)
    M = read_adjacency_list(Tv,Ti, alpha, edges)
    order, _ = size(M)
    new(alpha, accuracy, order, absorbing(M), M, ones(1, order) / order)
  end
end

function stationary_distribution(rank)
  r::Array{Float64, 1} = zeros(rank.order)
  last::Array{Float64, 1} = zeros(rank.order)
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

function absorbing(M::SparseMatrixCSC)
  # something like this?
  [1:M.n] - M.cols
end


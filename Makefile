.PHONY: test

test:
	cd ~/.julia/Pagerank && julia suite.jl

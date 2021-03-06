module Preconditioners

using JuLIP, LinearAlgebra

@doc raw"""
`AdjacancyPrecon` :

WARNING: While the code accounts for PBC, the following description does not.

If `(r0, r1, k)` is in the `intervals` list and if
`r0 <= rij <= r1` then the 3 x 3 block
```math
   P_{ij} = - k \big( (1-c) \hat{R}_{ij} \otimes \hat{R}_{ij} + c I \big),
```
where ``\hat{R}_{ij}`` is the bond direction and `c = innerstab`. The diagonal
is then obtained by
```math
   P_{ii} = \sum_{j \neq i} P_{ij} + c_g I
```
where `cg = stab` is a second, global, stabilisation constant.

Regarding the choice of `innerstab`:
* Choose `innerstab = 0` to get full infinitesimal rotation-invariance
* Choose `innerstab = 1` to get full resistance against infinitesimal rotations
* In optimisation we often found that `innerstab = 0.1` is a decent choice.
"""
struct AdjacancyPrecon
   intervals::Vector{NamedTuple{(:r0, :r1, :k), Tuple{Float64, Float64, Float64}}}
   stab::Float64
   innerstab::Float64
end

import JuLIP.FIO: read_dict, write_dict


AdjacancyPrecon(intervals; stab = 1e-4, innerstab = 0.1) =
   AdjacancyPrecon(intervals, stab, innerstab)

_cutoff(P::AdjacancyPrecon) =
   maximum( i.r1 for i in P.intervals )

function (P::AdjacancyPrecon)(R::JVecF)
   r = norm(R)
   R̂ = R / r
   Π = (1 - P.innerstab) * R̂ * R̂' + P.innerstab * one(JMat{Float64})
   for i in P.intervals
      if i.r0 <= r <= i.r1
         return i.k * Π
      end
   end
   return 0.0 * Π
end

function (precon::AdjacancyPrecon)(at::Atoms)
   P = zeros(3*length(at), 3*length(at))
   nlist = neighbourlist(at, _cutoff(precon))
   for i = 1:length(at)
      Js, Rs = neigs(nlist, i)
      for (j, Rij) in zip(Js, Rs)
         if j < i; continue; end
         Pij = precon(Rij)  
         inds = 3*(i-1) .+ (1:3)
         jnds = 3*(j-1) .+ (1:3)
         for a = 1:3, b = 1:3
            P[inds[a], jnds[b]] -= Pij[a,b]
            P[jnds[b], inds[a]] -= Pij[a,b]
            P[inds[a], inds[b]] += Pij[a,b]
            P[jnds[a], jnds[b]] += Pij[a,b]
         end
      end
   end
   P += precon.stab * I
   return P
end

end
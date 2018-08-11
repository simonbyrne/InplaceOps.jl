# InplaceOps.jl

[![Build Status](https://travis-ci.org/simonbyrne/InplaceOps.jl.svg?branch=master)](https://travis-ci.org/simonbyrne/InplaceOps.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/k1mn3g7mf43a5ce0/branch/master?svg=true)](https://ci.appveyor.com/project/simonbyrne/inplaceops-jl/branch/master)

InplaceOps.jl is a [Julia](http://julialang.org/) package that provides macros
that enable a simple syntax for performing in-place (i.e. overwriting) array
operations using standard arithmetic operators.

# Usage

InplaceOps.jl provides a macro `@!` which rewrites expressions of the form:
- `C = A*B` to `mul!(C,A,B)`
- `C = C*B` or `C *= B` to `rmul!(C,B)`
- `C = A*C` to `lmul!(A,B)`
- `C = A/B` to `rdiv!(C,A,B)`
- `C = C/B` or `C /= B` to `rdiv!(C,B)`
- `C = A\B` to `ldiv!(C,A,B)`
- `C = A\C` to `ldiv!(A,B)`

Functionality for broadcasting is no longer supported. Use the Base `@.` macro instead.

# Example

```julia
julia> using LinearAlgebra, InplaceOps

julia> T = UpperTriangular(ones(5,5))
5×5 UpperTriangular{Float64,Array{Float64,2}}:
 1.0  1.0  1.0  1.0  1.0
  ⋅   1.0  1.0  1.0  1.0
  ⋅    ⋅   1.0  1.0  1.0
  ⋅    ⋅    ⋅   1.0  1.0
  ⋅    ⋅    ⋅    ⋅   1.0

julia> x_orig = x = [1.0,2.0,3.0,4.0,5.0]
5-element Array{Float64,1}:
 1.0
 2.0
 3.0
 4.0
 5.0

julia> @! x = T \ x
5-element Array{Float64,1}:
 -1.0
 -1.0
 -1.0
 -1.0
  5.0

julia> x === x_orig
true
```

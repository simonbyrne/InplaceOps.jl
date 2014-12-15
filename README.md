# InplaceOps.jl

[![Build Status](https://travis-ci.org/simonbyrne/InplaceOps.jl.svg?branch=master)](https://travis-ci.org/simonbyrne/InplaceOps.jl)
[![Pkg status](http://pkg.julialang.org/badges/InplaceOps_release.svg)](http://pkg.julialang.org/?pkg=InplaceOps&ver=release)

InplaceOps.jl is a [Julia](http://julialang.org/) package that provides macros
that enable a simple syntax for performing in-place (i.e. overwriting) array
operations (`At_mul_B!` and the like, as well as `broadcast!`) using standard
arithmetic operators (`*`, `\`, ...; and their broadcasting equivalents `.*`,
...).

## Overwriting an array used in the operation

The macros `@in1!` and `@in2!` will overwrite the entries of the first and
second arguments respectively:

```julia
julia> using InplaceOps

julia> X = randn(5,5);

julia> C = cholfact(X'X)
Cholesky{Float64} with factor:
5x5 Triangular{Float64}:
 2.98062  0.357635  -1.42933  -1.40386     0.371712
 0.0      2.00525   -1.48687   4.4738e-5  -1.66761 
 0.0      0.0        1.37296   1.69426     0.430224
 0.0      0.0        0.0       0.5942      1.93128 
 0.0      0.0        0.0       0.0         1.07208 

julia> v = randn(5)
5-element Array{Float64,1}:
  0.633849 
 -1.92691  
 -0.817877 
  0.608644 
 -0.0069844

julia> pointer(v)
Ptr{Float64} @0x00007fcb313e3f70

julia> u = @in2! C \ v
5-element Array{Float64,1}:
   2.88607
 -47.6234 
 -51.754  
  43.7515 
 -10.5208 

julia> pointer(u)
Ptr{Float64} @0x00007fcb313e3f70
```

Note that it is not always possible to do operations in-place.
```julia
julia> @in2! X * v
ERROR: no method A_mul_B!(Array{Float64,2}, Array{Float64,1})
 in mul! at /Users/simon/.julia/v0.3/InplaceOps/src/InplaceOps.jl:40
```

## Overwriting a different array

If you want to put the output into an array that is not used internally, you
can use the `@into!` macro:
```julia
julia> u = Array(Float64,5);

julia> @into! u = X * v
5-element Array{Float64,1}:
  0.919228
 -5.40522 
  9.94378 
 -1.80869 
  5.51495 
```

## Warnings

You should generally not try to assign to an object that appears elsewhere
(unless you really know what you're doing). For example,
```julia
julia> X = randn(5,5)
5x5 Array{Float64,2}:
 -0.53897   -0.139062  -0.769589   1.35453     0.326885
  0.270242   1.24454   -0.700411   0.256821    0.225506
 -0.503335  -1.09109    1.14986    0.750931    2.58097 
  0.153684   1.33869   -1.07673   -1.55332    -0.596944
  0.996492  -1.12004    0.915189  -0.0312484   0.104354

julia> @into! X = X*X
5x5 Array{Float64,2}:
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
```

At the moment, `.+` and `.*` operators are only parsed as binary operators
(`x.+ y`), so *n*-ary operators (`x .+ y .+ z`) cannot be computed in one
step (see [#7368](https://github.com/JuliaLang/julia/issues/7368)).

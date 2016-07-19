module InplaceOps

isdefined(:__precompile__) && __precompile__(true)

include("Common.jl")

# In place math functions for all types
include("InplaceMath.jl")

# Inplace macros
include("Ops.jl")

end

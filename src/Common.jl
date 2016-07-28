import Base.LinAlg.BLAS: blascopy!, scal!, axpy!

immutable Inplace{N} end

immutable Transpose{T}
    obj::T
end
immutable CTranspose{T}
    obj::T
end

immutable Operator{S} end

cat_tuple(t1::Tuple, t2::Tuple) = tuple(t1...,t2...)

# Potential loss of precission when A and O have different types
function copy!(A::AbstractArray, O::AbstractArray)
    (size(O) != size(A)) && throw(DimensionMismatch("dimensions must match"))
    blascopy!(length(A), A, 1, O, 1)
end

# Add robustness to blascopy!
function blascopy!(::Number, DX::AbstractArray, ::Integer, DY::AbstractArray, ::Integer)
    for i in 1:length(DX)
        DY[i] = DX[i]
    end
    DY
end

# Potential errors when cant convert typeof(a*O[n]) to typeof(O[n])
scale!(a::Number, O::AbstractArray) = scal!(length(O), a, O, 1)

# Add robustness to scal!
function scal!(::Integer, DA::Number, DX::AbstractArray, ::Integer)
    for i in 1:length(DX)
       DX[i] *= DA
   end
   DX
end

import Base.LinAlg.BLAS: blascopy!, scal!, axpy!

# Potential loss of precission when A and O have different types
copy!(A::AbstractArray, O::AbstractArray) = blascopy!(length(A), A, 1, O, 1)

# Add robustness to blascopy!
function blascopy!(n::Number, DX::AbstractArray, incx::Integer, DY::AbstractArray, incy::Integer)
    x = 1
    y = 1
    nx = min(n, length(DX))
    ny = min(n, length(DY))
    while x <= nx && y <= ny
        DY[y] = DX[x]
        x += incx
        y += incy
    end
    DY
end

# Potential errors when cant convert typeof(a*O[n]) to typeof(O[n])
scale!(a::Number, O::AbstractArray) = scal!(length(O), a, O, 1)

# Add robustness to scal!
function scal!(n::Integer, DA::Number, DX::AbstractArray, incx::Integer)
    i = 1
    n = min(n,length(DX))
    while i <= n
        DX[i] *= DA
        i += incx
    end
    DX
end

############
# Addition #
############

# Turns out to be more expensive than allocating memory when adding few things
_add!(O::AbstractArray, ::Tuple{}) = O
_add!(O::AbstractArray, As::Tuple) = _add!(axpy!(1, As[1], O), Base.tail(As))
_add!{N}(::Type{Inplace{N}}, As...) = _add!(As[N], cat_tuple(As[1:N-1],As[N+1:end]))
_add!(O::AbstractArray, As...) = _add!(copy!(As[1], O), Base.tail(As))

################
# Substraction #
################

# Turns out to be more expensive than allocating memory
function _sub!(O::AbstractArray, A::AbstractArray, B::AbstractArray)
    size(O) == size(A) == size(B) || throw(DimensionMismatch("dimensions must match"))
    for i in 1:length(O)
        O[i] = A[i] - B[i]
    end
    O
end

_sub!(::Type{Inplace{1}}, O::AbstractArray, A::AbstractArray) = axpy!(-1, A, O)
_sub!{T}(::Type{Inplace{2}}, A::AbstractArray, O::AbstractArray{T}) = axpy!(1, A, scale!(T(-1),O))

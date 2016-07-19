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

addn!(O::AbstractArray, ::Tuple{}) = O
addn!(O::AbstractArray, As::Tuple) = addn!(axpy!(1, As[1], O), Base.tail(As))

################
# Substraction #
################

sub!(n::Integer, A::AbstractArray, B::AbstractArray) = sub!(Val{n},A,B)
sub!(::Type{Val{1}}, O::AbstractArray, A::AbstractArray) = axpy!(-1, A, O)
sub!{T}(::Type{Val{2}}, A::AbstractArray, O::AbstractArray{T}) = axpy!(1, A, scale!(T(-1),O))

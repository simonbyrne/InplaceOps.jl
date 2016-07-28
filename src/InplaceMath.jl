############
# Addition #
############

_add!(O::AbstractArray, ::Tuple{}) = O
_add!(O::AbstractArray, As::Tuple) = _add!(axpy!(1, As[1], O), Base.tail(As))
_add!{N}(::Type{Inplace{N}}, As...) = _add!(As[N], cat_tuple(As[1:N-1],As[N+1:end]))
_add!(O::AbstractArray, As...) = _add!(copy!(As[1], O), Base.tail(As))

################
# Substraction #
################

# Turns out to be more expensive than not allocating memory
function _sub!(O::AbstractArray, A::AbstractArray, B::AbstractArray)
    size(O) == size(A) == size(B) || throw(DimensionMismatch("dimensions must match"))
    for i in 1:length(O)
        O[i] = A[i] - B[i]
    end
    O
end

_sub!(::Type{Inplace{1}}, O::AbstractArray, A::AbstractArray) = axpy!(-1, A, O)
_sub!{T}(::Type{Inplace{2}}, A::AbstractArray, O::AbstractArray{T}) = axpy!(1, A, scale!(T(-1),O))

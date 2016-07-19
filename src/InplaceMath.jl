export

function copy!(O::AbstractArray, A::AbstractArray)
    (size(O) != size(A)) && throw(DimensionMismatch("dimensions must match"))
    for i in 1:length(A)
        O[i] = A[i]
    end
    O
end

_addn!(O::AbstractArray, ::Tuple{}) = O
_addn!(O::AbstractArray, As::Tuple) = _addn!(_add2!(O, As[1]), Base.tail(As))

function _add2!(O::AbstractArray, A::AbstractArray)
    (size(O) != size(A)) && throw(DimensionMismatch("dimensions must match"))
    for i in 1:length(A)
        O[i] += A[i]
    end
    O
end

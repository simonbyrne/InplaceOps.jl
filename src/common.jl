immutable Inplace{N} end

immutable Transpose{T}
    obj::T
end
immutable CTranspose{T}
    obj::T
end

immutable Operator{S} end

cat_tuple(t1::Tuple, t2::Tuple) = tuple(t1...,t2...)

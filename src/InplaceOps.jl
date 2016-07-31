isdefined(:__precompile__) && __precompile__(true)
module InplaceOps

include("common.jl")
include("inplace_math.jl")

export @in1!, @in2!, @into!

inplace_sym(s::Symbol) = inplace_sym(Operator{s}())

inplace_sym{S}(::Operator{S}) = error("invalid operator")

inplace_sym(::Operator{:+}) = :add!
inplace_sym(::Operator{:-}) = :sub!
inplace_sym(::Operator{:*}) = :mul!
inplace_sym(::Operator{:\}) = :ldiv!
inplace_sym(::Operator{:/}) = :rdiv!

inplace_sym(::Operator{:.+}) = :badd!
inplace_sym(::Operator{:.-}) = :bsub!
inplace_sym(::Operator{:.*}) = :bmul!
inplace_sym(::Operator{:.\}) = :bldiv!
inplace_sym(::Operator{:./}) = :brdiv!


op_ctranspose{T}(x::AbstractArray{T}) = CTranspose(x)
op_ctranspose{T<:Real}(x::AbstractArray{T}) = Transpose(x)

op_transpose{T}(x::AbstractArray{T}) = Transpose(x)

typealias AbstractVMF Union{AbstractVecOrMat,Factorization}

#TODO: Most of the 2-argument A_foo_B methods overwrite B, though there are some exceptions (e.g. QRPackedQ)
mul!(::Type{Inplace{2}}, A::AbstractVMF, B::AbstractVMF) = A_mul_B!(A,B)
mul!(::Type{Inplace{2}}, A::Transpose  , B::AbstractVMF) = At_mul_B!(A.obj,B)
mul!(::Type{Inplace{2}}, A::CTranspose , B::AbstractVMF) = Ac_mul_B!(A.obj,B)

ldiv!(::Type{Inplace{2}}, A::AbstractVMF, B::AbstractVMF) = A_ldiv_B!(A,B)
ldiv!(::Type{Inplace{2}}, A::Transpose  , B::AbstractVMF) = At_ldiv_B!(A.obj,B)
ldiv!(::Type{Inplace{2}}, A::CTranspose , B::AbstractVMF) = Ac_ldiv_B!(A.obj,B)

rdiv!(::Type{Inplace{2}}, A::AbstractVMF, B::AbstractVMF) = A_rdiv_B!(A,B)
rdiv!(::Type{Inplace{2}}, A::Transpose  , B::AbstractVMF) = At_rdiv_B!(A.obj,B)
rdiv!(::Type{Inplace{2}}, A::CTranspose , B::AbstractVMF) = Ac_rdiv_B!(A.obj,B)

mul!(O::AbstractVMF, A::AbstractVMF, B::AbstractVMF) = A_mul_B!(O,A,B)
mul!(O::AbstractVMF, A::Transpose  , B::AbstractVMF) = At_mul_B!(O,A.obj,B)
mul!(O::AbstractVMF, A::CTranspose , B::AbstractVMF) = Ac_mul_B!(O,A.obj,B)
mul!(O::AbstractVMF, A::AbstractVMF, B::Transpose  ) = A_mul_Bt!(O,A,B.obj)
mul!(O::AbstractVMF, A::Transpose  , B::Transpose  ) = At_mul_Bt!(O,A.obj,B.obj)
mul!(O::AbstractVMF, A::CTranspose , B::Transpose  ) = Ac_mul_Bt!(O,A.obj,B.obj)
mul!(O::AbstractVMF, A::AbstractVMF, B::CTranspose ) = A_mul_Bc!(O,A,B.obj)
mul!(O::AbstractVMF, A::Transpose  , B::CTranspose ) = At_mul_Bc!(O,A.obj,B.obj)
mul!(O::AbstractVMF, A::CTranspose , B::CTranspose ) = Ac_mul_Bc!(O,A.obj,B.obj)

ldiv!(O::AbstractVMF, A::AbstractVMF, B::AbstractVMF) = A_ldiv_B!(O,A,B)
ldiv!(O::AbstractVMF, A::Transpose  , B::AbstractVMF) = At_ldiv_B!(O,A.obj,B)
ldiv!(O::AbstractVMF, A::CTranspose , B::AbstractVMF) = Ac_ldiv_B!(O,A.obj,B)
ldiv!(O::AbstractVMF, A::AbstractVMF, B::Transpose  ) = A_ldiv_Bt!(O,A,B.obj)
ldiv!(O::AbstractVMF, A::Transpose  , B::Transpose  ) = At_ldiv_Bt!(O,A.obj,B.obj)
ldiv!(O::AbstractVMF, A::CTranspose , B::Transpose  ) = Ac_ldiv_Bt!(O,A.obj,B.obj)
ldiv!(O::AbstractVMF, A::AbstractVMF, B::CTranspose ) = A_ldiv_Bc!(O,A,B.obj)
ldiv!(O::AbstractVMF, A::Transpose  , B::CTranspose ) = At_ldiv_Bc!(O,A.obj,B.obj)
ldiv!(O::AbstractVMF, A::CTranspose , B::CTranspose ) = Ac_ldiv_Bc!(O,A.obj,B.obj)

rdiv!(O::AbstractVMF, A::AbstractVMF, B::AbstractVMF) = A_rdiv_B!(O,A,B)
rdiv!(O::AbstractVMF, A::Transpose  , B::AbstractVMF) = At_rdiv_B!(O,A.obj,B)
rdiv!(O::AbstractVMF, A::CTranspose , B::AbstractVMF) = Ac_rdiv_B!(O,A.obj,B)
rdiv!(O::AbstractVMF, A::AbstractVMF, B::Transpose  ) = A_rdiv_Bt!(O,A,B.obj)
rdiv!(O::AbstractVMF, A::Transpose  , B::Transpose  ) = At_rdiv_Bt!(O,A.obj,B.obj)
rdiv!(O::AbstractVMF, A::CTranspose , B::Transpose  ) = Ac_rdiv_Bt!(O,A.obj,B.obj)
rdiv!(O::AbstractVMF, A::AbstractVMF, B::CTranspose ) = A_rdiv_Bc!(O,A,B.obj)
rdiv!(O::AbstractVMF, A::Transpose  , B::CTranspose ) = At_rdiv_Bc!(O,A.obj,B.obj)
rdiv!(O::AbstractVMF, A::CTranspose , B::CTranspose ) = Ac_rdiv_Bc!(O,A.obj,B.obj)

badd!{N}(::Type{Inplace{N}}, As...) = broadcast!(+,As[N],As...)
bsub!{N}(::Type{Inplace{N}}, As...) = broadcast!(-,As[N],As...)
bmul!{N}(::Type{Inplace{N}}, As...) = broadcast!(*,As[N],As...)
bldiv!{N}(::Type{Inplace{N}}, As...) = broadcast!(\,As[N],As...)
brdiv!{N}(::Type{Inplace{N}}, As...) = broadcast!(/,As[N],As...)
add!{N}(t::Type{Inplace{N}}, As...) = _add!(t, As...)
sub!{N}(t::Type{Inplace{N}}, As...) = _sub!(t, As...)

badd!(O::AbstractArray, As...) = broadcast!(+,O,As...)
bsub!(O::AbstractArray, As...) = broadcast!(-,O,As...)
bmul!(O::AbstractArray, As...) = broadcast!(*,O,As...)
bldiv!(O::AbstractArray, As...) = broadcast!(\,O,As...)
brdiv!(O::AbstractArray, As...) = broadcast!(/,O,As...)
add!(O::AbstractArray, As...) = _add!(O, As...)
sub!(O::AbstractArray, As...) = _sub!(O, As...)

replace_t(ex) = esc(ex)
function replace_t(ex::Expr)
    if ex.head == symbol("'")
        :(op_ctranspose($(esc(ex.args[1]))))
    elseif ex.head == symbol(".'")
        :(op_transpose($(esc(ex.args[1]))))
    else
        esc(ex)
    end
end


macro in1!(ex)
    ex.head == :call || error("incorrect macro usage")
    Expr(:call,inplace_sym(ex.args[1]),:(Inplace{1}),[replace_t(a) for a in ex.args[2:end]]...)
end

macro in2!(ex)
    ex.head == :call || error("incorrect macro usage")
    Expr(:call,inplace_sym(ex.args[1]),:(Inplace{2}),[replace_t(a) for a in ex.args[2:end]]...)
end

macro into!(ex)
    ex.head == :(=) || error("incorrect macro usage")
    out, ex = ex.args
    Expr(:call,inplace_sym(ex.args[1]),esc(out),[replace_t(a) for a in ex.args[2:end]]...)
end

end

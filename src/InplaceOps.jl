module InplaceOps

using LinearAlgebra

export @!

macro !(ex)
    if ex.head == :(=)
        C, ex2 = ex.args
        if ex2.head == :call
            op = ex2.args[1]
            length(ex2.args) == 3 || error("@! macro only supports 2-argument functions")
            A = ex2.args[2]
            B = ex2.args[3]
        else
            error("Invalid use of @! macro")
        end
    elseif ex.head in (:*=, :/=)
        op = Symbol(String(ex.head)[1:1])
        C = A = ex.args[1]
        B = ex.args[2]
    else
        error("@! does not support this expression")
    end
    C isa Symbol || error("Invalid use of @! macro")        

    if op == :/
        if C == B
            error("@! macro cannot reuse array")
        elseif C == A
            return :($(esc(C)) = rdiv!($(esc(A)), $(esc(B))))
        else
            return :($(esc(C)) = rdiv!($(esc(C)), $(esc(A)), $(esc(B))))
        end
    elseif op == :\
        if C == A
            error("@! macro cannot reuse array")
        elseif C == B
            return :($(esc(C)) = ldiv!($(esc(A)), $(esc(B))))
        else
            return :($(esc(C)) = ldiv!($(esc(C)), $(esc(A)), $(esc(B))))
        end
    elseif op == :*
        if C == A
            if C == B
                error("@! macro cannot reuse array")
            end
            return :($(esc(C)) = rmul!($(esc(A)), $(esc(B))))
        elseif C == B
            return :($(esc(C)) = lmul!($(esc(A)), $(esc(B))))
        else
            return :($(esc(C)) = mul!($(esc(C)), $(esc(A)), $(esc(B))))
        end
    end
end

end  # module

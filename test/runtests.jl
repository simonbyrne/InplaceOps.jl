using InplaceOps
using Test, LinearAlgebra

n = 10

X = randn(n,n)

v = randn(n)
v_orig = v

Z = randn(n,n)
Z_orig = Z


C = cholesky(X'X)
v_check = C \ v
@! v = C \ v
@test v == v_check
@test v === v_orig

A = qr(X)
v_check = A.Q * v
@! v = A.Q * v
@test v == v_check
@test v === v_orig

@test_throws MethodError (u = ones(10); @! u = A*u)

Z_check = X * X
@! Z = X * X
@test Z == Z_check
@test Z === Z_orig

@test_throws MethodError (U = ones(10,10); @! U = U*X)
@test_throws MethodError (U = ones(10,10); @! U = X*U)
@test_throws MethodError (U = ones(10,10); @! U *= X)

Z_check = X' * X
@! Z = X' * X
@test Z == Z_check
@test Z === Z_orig

Z_check = X * X'
@! Z = X * X'
@test Z == Z_check
@test Z === Z_orig

# duplicate tests with immutable struct wrapper
struct immutable_wrapper
    X
    v
    Z
    u
    U
end

S = immutable_wrapper(randn(n,n), randn(n), randn(n,n), ones(10), ones(10,10))

v_orig = S.v
Z_orig = S.Z

C = cholesky(S.X'S.X)
v_check = C \ S.v
@! S.v = C \ S.v
@test S.v == v_check
@test S.v === v_orig

A = qr(S.X)
v_check = A.Q * S.v
@! S.v = A.Q * S.v
@test S.v == v_check
@test S.v === v_orig

@test_throws MethodError (@! S.u = A*S.u)

Z_check = S.X * S.X
@! S.Z = S.X * S.X
@test S.Z == Z_check
@test S.Z === Z_orig

@test_throws MethodError (@! S.U = S.U*S.X)
@test_throws MethodError (@! S.U = S.X*S.U)
@test_throws MethodError (@! S.U *= S.X)

Z_check = S.X' * S.X
@! S.Z = S.X' * S.X
@test S.Z == Z_check
@test S.Z === Z_orig

Z_check = S.X * S.X'
@! S.Z = S.X * S.X'
@test S.Z == Z_check
@test S.Z === Z_orig
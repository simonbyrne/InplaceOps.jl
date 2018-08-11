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

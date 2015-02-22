using InplaceOps
using Base.Test

X = randn(10,10)
v = randn(10)
y = randn()

pX = pointer(X)
pv = pointer(v)

C = cholfact(X'X)
u = C \ v
@in2! C \ v
@test u == v
@test pv == pointer(v)

A = qrfact(X)
u = A[:Q] * v
@in2! A[:Q] * v
@test u == v
@test pv == pointer(v)

Y = X .+ v .+ y
@in1! X .+ v
@in1! X .+ y
@test Y == X
@test pX == pointer(X)

pY = pointer(Y)
Z = X * X
@into! Y = X * X
@test Y == Z
@test pY == pointer(Y)

pY = pointer(Y)
Z = X' * X
@into! Y = X' * X
@test Y == Z
@test pY == pointer(Y)

pY = pointer(Y)
Z = X * X'
@into! Y = X * X'
@test Y == Z
@test pY == pointer(Y)


Z = X .+ v
@into! Y = X .+ v
@test Y == Z
@test pY == pointer(Y)

Z = X .+ y
@into! Y = X .+ y
@test Y == Z
@test pY == pointer(Y)

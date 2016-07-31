using InplaceOps
using Base.Test

n = 10

X = randn(n,n)
v = randn(n)
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


A = rand(n,n)
B = rand(n,n)
C = rand(n,n)
D = rand(n,n)

pA = pointer(A)

D = A + B + C
@in1! A + C
@in2! B + A
@test D == A
@test pA == pointer(A)

pA = pointer(A)

D = A - B
@in1! A - B
@test D == A
@test pA == pointer(A)

D = B - A
@in2! B - A
@test D == A
@test pA == pointer(A)

pD = pointer(D)

@into! D = A + B + C
@test D == A + B + C
@test pD == pointer(D)

@into! D = A - B
@test D == A - B
@test pD == pointer(D)

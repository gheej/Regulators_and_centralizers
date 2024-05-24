a_const, b_const = 3, -5
primes = []
centralizer_index = []
regulators = []
for i in range(3, 80):
    p = Primes().unrank(i)

    R.<x> = PolynomialRing(QQ)

    P = x^3 - (a_const * p) * x^2 - (b_const * p + a_const) * x - b_const

    if not P.is_irreducible():
        print("NOT IRREDUCIBLE")
    # Create a field extension with a root of p
    K.<a> = QQ.extension(P)

    UK = UnitGroup(K)
    generatorrs = UK.gens_values()

    T.<y> = PolynomialRing(GF(p))
    Q = y^3 - a_const * y - b_const
    if not Q.is_irreducible():
        print(p, i, Q.factor())
    else:
        L.<b> = GF(p).extension(P)
        primes.append(p)
        centralizer_index.append(max([sum([b^i * L(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]))
        regulators.append(K.regulator())

from matplotlib import pyplot as plt

fig, ax = plt.subplots()

ax.plot(primes, centralizer_index, label='index of the centralizers')
ax.plot(primes, regulators, label='regulators')
ax.set_xlabel('primes')
ax.set_title('Unramified primes, a={}, b={}'.format(a_const, b_const))
ax.legend()
plt.savefig('pic_regulators_and_centralizers_unramified.png')
#plt.show()


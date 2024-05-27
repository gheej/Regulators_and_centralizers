a_const, b_const = 2, 7
n_primes = 50 # but starting from 5

def printProgressBar (iteration, total, prime, case, prefix = '', suffix = '', decimals = 1, length = 100, fill = '█', printEnd = "\r"):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}, Prime {prime} case {case}', end = printEnd)
    # Print New Line on Complete
    if iteration == total:
        print()

from itertools import chain

primes_1, primes_2, primes_3, primes_4 = [], [], [], []
centralizer_index_1,  centralizer_index_2,  centralizer_index_3,  centralizer_index_4 = [], [], [], []
regulators_1, regulators_2, regulators_3, regulators_4 = [], [], [], []

def what_happens(factors):
    if len(factors) == 1:
        # unramified
        return 1
    elif len(factors) == 2:
        if factors[0][1] + factors[0][1] == 3:
            # ramified split
            return 2
        else:
            # ramified nonsplit
            return 3
    # completely split
    return 4

for i in range(3, n_primes):
    p = Primes().unrank(i)

    R.<x> = PolynomialRing(QQ)
    P = x^3 - (a_const * p) * x^2 - (b_const * p + a_const) * x - b_const

    if not P.is_irreducible():
        print("NOT IRREDUCIBLE")
        break
    # Create a field extension with a root of p
    K.<a> = QQ.extension(P)

    UK = UnitGroup(K)
    generatorrs = UK.gens_values()
    generatorrs = list(chain(*[[gen, -gen] for gen in generatorrs])) # add negatives to ensure independence of the choice of the sign

    T.<y> = PolynomialRing(GF(p))
    Q = y^3 - a_const * y - b_const

    printProgressBar(i, n_primes, prime = p, case = what_happens(Q.factor()), prefix = 'Progress:', suffix = 'Complete', length = 50)

    if what_happens(Q.factor()) == 1: # unramified
        L.<b> = GF(p).extension(P)
        primes_1.append(p)
        centralizer_index_1.append(max([sum([b^i * L(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]))
        regulators_1.append(K.regulator())
    elif what_happens(Q.factor()) == 2: # ramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        T = [[sum([b1^i * L1(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b2^i * L2(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]]

        primes_2.append(p)
        centralizer_index_2.append(max( [ lcm([T[0][i],  T[1][i]]) for i in range(6)]))
        regulators_2.append(K.regulator())
    elif what_happens(Q.factor()) == 3: # unramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        T = [[sum([b1^i * L1(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b2^i * L2(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]]

        primes_3.append(p)
        centralizer_index_3.append(max( [ lcm([T[0][i],  T[1][i]]) for i in range(6)]))
        regulators_3.append(K.regulator())
    else: #splits completely
        Q1, Q2, Q3 = Q.factor()
        Q1, Q2, Q3 = Q1[0], Q2[0], Q3[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        L3.<b3> = GF(p).extension(Q3)
        T = [[sum([b1^i * L1(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b2^i * L2(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b3^i * L3(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]]

        primes_4.append(p)
        centralizer_index_4.append(max( [ lcm([T[0][i],  T[1][i],  T[2][i]]) for i in range(6)]))
        regulators_4.append(K.regulator())

from matplotlib import pyplot as plt

fig, axes = plt.subplots(2, 2, figsize=(12, 8))

axes[0, 0].plot(primes_1, centralizer_index_1, label='Index of the Centralizers')
axes[0, 0].plot(primes_1, regulators_1, label='Regulators')
axes[0, 0].set_xlabel('Primes')
axes[0, 0].set_title('Unramified Primes, a={}, b={}'.format(a_const, b_const))
axes[0, 0].legend(loc='best')

axes[0, 1].plot(primes_2, centralizer_index_2, label='Index of the Centralizers')
axes[0, 1].plot(primes_2, regulators_2, label='Regulators')
axes[0, 1].set_xlabel('Primes')
axes[0, 1].set_title('Ramified Split Primes, a={}, b={}'.format(a_const, b_const))
axes[0, 1].legend(loc='best')

axes[1, 0].plot(primes_3, centralizer_index_3, label='Index of the Centralizers')
axes[1, 0].plot(primes_3, regulators_3, label='Regulators')
axes[1, 0].set_xlabel('Primes')
axes[1, 0].set_title('Ramified Nonsplit Primes, a={}, b={}'.format(a_const, b_const))
axes[1, 0].legend(loc='best')

axes[1, 1].plot(primes_4, centralizer_index_4, label='Index of the Centralizers')
axes[1, 1].plot(primes_4, regulators_4, label='Regulators')
axes[1, 1].set_xlabel('Primes')
axes[1, 1].set_title('Completely Split Primes, a={}, b={}'.format(a_const, b_const))
axes[1, 1].legend(loc='best')

plt.tight_layout()

plt.savefig('pic_regulators_and_centralizers_a_{}_b_{}_n_primes_{}.png'.format(a_const, b_const, n_primes))
print('Output written to pic_regulators_and_centralizers_a_{}_b_{}_n_primes_{}.png'.format(a_const, b_const, n_primes))

#plt.show()


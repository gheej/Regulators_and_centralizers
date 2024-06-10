from itertools import chain, product
from sage.misc.prandom import randrange
from sage.arith.functions import LCM_list
set_random_seed(34)

Prime = Primes().unrank(100)
k = 30
a_range = [randrange(-k, k) for i in range(20)]
b_range = [-1, 1]
total = len(a_range) * len(b_range)
print(Prime, a_range, b_range)

def printProgressBar (iteration, total, a_const, b_const, case, prefix = '', suffix = '', decimals = 1, length = 100, fill = '█', printEnd = "\r"):
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
    print(f'\r{prefix} |{bar}| {percent}% {suffix}, a {a_const} b {b_const} case {case}', end = printEnd)
    print()
    # Print New Line on Complete
    if iteration == total:
        print('\n\n')

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


params_1, params_2, params_3, params_4 = [], [], [], []

centralizer_index_1,  centralizer_index_2,  centralizer_index_3,  centralizer_index_4 = [], [], [], []
regulators_1, regulators_2, regulators_3, regulators_4 = [], [], [], []

for i, (a_const, b_const) in enumerate(product(a_range, b_range)):
    p = Prime

    R.<x> = PolynomialRing(QQ)
    P = x^3 - (a_const * p) * x^2 - (b_const * p + a_const) * x - b_const

    if not P.is_irreducible():
        print("NOT IRREDUCIBLE")
        continue
    # Create a field extension with a root of p
    K.<a> = QQ.extension(P)

    #UK = UnitGroup(K)

    T.<y> = PolynomialRing(GF(p))
    Q = y^3 - a_const * y - b_const

    printProgressBar(i, total, a_const, b_const, case = what_happens(Q.factor()), prefix = 'Progress:', suffix = 'Complete', length = 50)

    if what_happens(Q.factor()) == 1: # unramified
        L.<b> = GF(p).extension(P)

        print(a_const, b_const, K.regulator(), b.multiplicative_order())
        params_1.append((a_const, b_const))
        centralizer_index_1.append(b.multiplicative_order())
        regulators_1.append(K.regulator())
    elif what_happens(Q.factor()) == 2: # ramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)

        print(a_const, b_const, K.regulator(), b1.multiplicative_order(), b2.multiplicative_order())
        params_2.append((a_const, b_const))
        centralizer_index_2.append(lcm(b1.multiplicative_order(), b2.multiplicative_order()))
        regulators_2.append(K.regulator())
    elif what_happens(Q.factor()) == 3: # unramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)

        print(a_const, b_const, K.regulator(), b1.multiplicative_order(), b2.multiplicative_order())
        params_3.append((a_const, b_const))
        centralizer_index_3.append(lcm(b1.multiplicative_order(), b2.multiplicative_order()))
        regulators_3.append(K.regulator())
    else: #splits completely
        Q1, Q2, Q3 = Q.factor()
        Q1, Q2, Q3 = Q1[0], Q2[0], Q3[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        L3.<b3> = GF(p).extension(Q3)

        print(a_const, b_const, K.regulator(), b1.multiplicative_order(), b2.multiplicative_order(), b3.multiplicative_order())
        params_4.append((a_const, b_const))
        centralizer_index_4.append(LCM_list([b1.multiplicative_order(), b2.multiplicative_order(), b3.multiplicative_order()]))
        regulators_4.append(K.regulator())

print('\n\n')
print(len(params_1), len(params_2), len(params_3), len(params_4) )

pairs = zip(params_1, regulators_1, centralizer_index_1)
max(pairs, key=lambda x: x[1] * x[2])


print('\nUnramified:')
print('a, b:', params_1, sep='\t')
print('Regulator:', regulators_1, sep='\t') 
print('Degree:', centralizer_index_1, sep='\t')
pairs = list(zip(params_1, regulators_1, centralizer_index_1))
if pairs: 
    print('Min volume', min(pairs, key=lambda x: x[1] * x[2]))

print('\nRamified split:')
# print(params_2, regulators_2, centralizer_index_2, sep='\n')
print('a, b:', params_2, sep='\t')
print('Regulator:', regulators_2, sep='\t') 
print('Degree:', centralizer_index_2, sep='\t')
pairs = list(zip(params_2, regulators_2, centralizer_index_2))
if pairs: 
    print('Min volume', min(pairs, key=lambda x: x[1] * x[2]))
print('\nRamified nonsplit:')
# print(params_3, regulators_3, centralizer_index_3, sep='\n')
print('a, b:', params_3, sep='\t')
print('Regulator:', regulators_3, sep='\t') 
print('Degree:', centralizer_index_3, sep='\t')
pairs = list(zip(params_3, regulators_3, centralizer_index_3))
if pairs: 
    print('Min volume', min(pairs, key=lambda x: x[1] * x[2]))
print('\nCompletely split:')
# print(params_4, regulators_4, centralizer_index_4, sep='\n')
print('a, b:', params_4, sep='\t')
print('Regulator:', regulators_4, sep='\t') 
print('Degree:', centralizer_index_4, sep='\t')
pairs = list(zip(params_4, regulators_4, centralizer_index_4))
if pairs: 
    print('Min volume', min(pairs, key=lambda x: x[1] * x[2]))

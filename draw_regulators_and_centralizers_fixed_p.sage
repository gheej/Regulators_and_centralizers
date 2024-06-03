Prime = 173
a_range = range(1, 15)
b_range = range(-7, 7)
total = len(a_range) * len(b_range)

from itertools import chain, product

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

    UK = UnitGroup(K)
    generatorrs = UK.gens_values()
    generatorrs = list(chain(*[[gen, -gen] for gen in generatorrs])) # add negatives to ensure independence of the choice of the sign

    T.<y> = PolynomialRing(GF(p))
    Q = y^3 - a_const * y - b_const

    printProgressBar(i, total, a_const, b_const, case = what_happens(Q.factor()), prefix = 'Progress:', suffix = 'Complete', length = 50)

    if what_happens(Q.factor()) == 1: # unramified
        L.<b> = GF(p).extension(P)
        params_1.append((a_const, b_const))
        centralizer_index_1.append(max([sum([b^i * L(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]))
        regulators_1.append(K.regulator())
    elif what_happens(Q.factor()) == 2: # ramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        T = [[sum([b1^i * L1(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b2^i * L2(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]]

        params_2.append((a_const, b_const))
        centralizer_index_2.append(max( [ lcm([T[0][i],  T[1][i]]) for i in range(6)]))
        regulators_2.append(K.regulator())
    elif what_happens(Q.factor()) == 3: # unramified split
        Q1, Q2 = Q.factor()
        Q1, Q2 = Q1[0], Q2[0]
        L1.<b1> = GF(p).extension(Q1)
        L2.<b2> = GF(p).extension(Q2)
        T = [[sum([b1^i * L1(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs], \
        [sum([b2^i * L2(coef) for i, coef in enumerate(gen.polynomial().coefficients())]).multiplicative_order() for gen in generatorrs]]

        params_3.append((a_const, b_const))
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

        params_4.append((a_const, b_const))
        centralizer_index_4.append(max( [ lcm([T[0][i],  T[1][i],  T[2][i]]) for i in range(6)]))
        regulators_4.append(K.regulator())

print('\n\n')
print(len(params_1), len(params_2), len(params_3), len(params_4) )


print(params_1, regulators_1, centralizer_index_1)
print(params_2, regulators_2, centralizer_index_2)
print(params_3, regulators_3, centralizer_index_3)
print(params_4, regulators_4, centralizer_index_4)

import numpy
params_1 = numpy.asarray(params_1)
numpy.savetxt("params_1.csv", params_1 , delimiter=",")
centralizer_index_1 = numpy.asarray(centralizer_index_1)
numpy.savetxt("centralizer_index_1.csv", centralizer_index_1 , delimiter=",")
regulators_1 = numpy.asarray(regulators_1)
numpy.savetxt("regulators_1.csv", regulators_1 , delimiter=",")


params_2 = numpy.asarray(params_2)
numpy.savetxt("params_2.csv", params_2 , delimiter=",")
centralizer_index_2 = numpy.asarray(centralizer_index_2)
numpy.savetxt("centralizer_index_2.csv", centralizer_index_2 , delimiter=",")
regulators_2 = numpy.asarray(regulators_2)
numpy.savetxt("regulators_2.csv", regulators_2 , delimiter=",")


params_3 = numpy.asarray(params_3)
numpy.savetxt("params_3.csv", params_3 , delimiter=",")
centralizer_index_3 = numpy.asarray(centralizer_index_3)
numpy.savetxt("centralizer_index_3.csv", centralizer_index_3 , delimiter=",")
regulators_3 = numpy.asarray(regulators_3)
numpy.savetxt("regulators_3.csv", regulators_3 , delimiter=",")


params_4 = numpy.asarray(params_4)
numpy.savetxt("params_4.csv", params_4 , delimiter=",")
centralizer_index_4 = numpy.asarray(centralizer_index_4)
numpy.savetxt("centralizer_index_4.csv", centralizer_index_4 , delimiter=",")
regulators_4 = numpy.asarray(regulators_4)
numpy.savetxt("regulators_4.csv", regulators_4 , delimiter=",")


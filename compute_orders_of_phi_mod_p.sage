from matplotlib import pyplot as plt
orders_sq = []
orders_not_sq = []
for i, p in enumerate(Primes()):
    if p == 2:
        continue
    if i > 1000:
        break
    k = GF(p)    
    phi = (1 + sqrt(k(5)))/2
    ordd = multiplicative_order(phi)
    if is_square(k(5)):
        orders_sq.append((p, ordd))
    else:
        orders_not_sq.append((p, ordd))
print(*orders_sq)
print(*orders_not_sq)

fig, ax = plt.subplots()
ax.scatter([i[0] for i in orders_sq], [i[1] for i in orders_sq], label='sqrt(5) exists in F_p', marker='.')
ax.scatter([i[0] for i in orders_not_sq], [i[1] for i in orders_not_sq], label='sqrt(5) exists only in F_{p^2}', marker='.')
ax.set_xlabel('prime p')
ax.set_ylabel('order of phi mod F_p or F_{p^2}')
ax.legend()
plt.savefig('graph_scatter_plot_orders_of_phi_mod_p.png')
#plt.show()


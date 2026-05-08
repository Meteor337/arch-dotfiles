n = int(input())
purchases = {}
for _ in range(n):
    buyer, product, quantity = input().split()
    quantity = int(quantity)
    if buyer not in purchases:
        purchases[buyer] = {}
    if product in purchases[buyer]:
        purchases[buyer][product] += quantity
    else:
        purchases[buyer][product] = quantity
for buyer in sorted(purchases.keys()):
    print(f"{buyer}:")
    for product in sorted(purchases[buyer].keys()):
        print(f"{product} {purchases[buyer][product]}")


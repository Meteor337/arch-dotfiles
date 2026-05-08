import random


def get_secret_friend(students):
    shuffled = list(students)
    random.shuffle(shuffled)
    result = {}
    for i in range(len(students)):
        result[shuffled]

students = ("Светлана", "Аркадий", "Борис")
for name, friend in get_secret_friend(students).items():
    print(name, "-", friend)

student_ids = ["X142", "B065", "X144"]
student_names = ["Nikita Karpov", "Anna Chernova", "Ruslan Magarov"]
student_grades = [88, 85, 62]
res = [
    {ids: {name: grade}}
    for ids, name, grade in zip(student_ids, student_names, student_grades)
]
print(res)

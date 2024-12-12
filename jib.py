from main2 import serach_all_json

Criteria={"L2": "True"}
a=serach_all_json("Windows",Criteria)
print(len(a))

b=serach_all_json("rhel_9",Criteria)
print(len(b))

c=serach_all_json("Ubuntu",Criteria)
print(len(c))
# Python3 program to Convert a
# list to dictionary

def Convert(lst):
    res_dct = {lst[i]: lst[i + 1] for i in range(0, len(lst), 2)}
    return res_dct

# Driver code
lst = ['a', 1, 'b', 2, 'c', 3]
print(Convert(lst))

# class my_dictionary(dict):

#     # __init__ function
#     def __init__(self):
#         self = dict()

#     # Function to add key:value
#     def add(self, key, value):
#         self[key] = value


# # Main Function
# dict_obj = my_dictionary()

# dict_obj.add(1, 'Geeks')
# dict_obj.add(2, 'forGeeks')
# dict_obj.add(3, 'forGeeks')
# dict_obj.add(2, 'forGeeks')

# print(dict_obj)

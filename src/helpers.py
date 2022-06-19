'''Helper functions'''

def count_str_chars(string: str, char: str) -> int:
    '''Count occurences of a character in a string'''
    return len(list(filter(lambda x: x == char, [*string])))

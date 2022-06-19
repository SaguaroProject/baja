
from enum import Enum
from termcolor import colored, cprint
from helpers import count_str_chars

class Color(Enum):
    '''Console output colors'''
    INFO = 'white'
    SUCCESS = 'green'
    WARN = 'yellow'
    ERROR = 'red'

class Output:
    '''Side effect wrapper for printing to the console'''

    def print(self, message: str, color: Color):
        '''Print a message to the terminal'''
        cprint(colored(message, color.value))


class Console:
    '''Console helper'''

    DEFAULT_COLOR = Color.INFO

    def __init__(self, output: Output, verbosity: str = ''):
        self.__output = output
        self.__verbosity = verbosity

    def __print(self, message: str, color: Color = DEFAULT_COLOR, verbose: str = ''):
        '''Print a message to the console'''
        if count_str_chars(verbose, 'v') <= count_str_chars(self.__verbosity, 'v'):
            self.__output.print(message, color)

    def info(self, message: str, verbose: str = ''):
        '''Print an info message to the console'''
        self.__print(message, Color.INFO, verbose)

    def success(self, message: str, verbose: str = ''):
        '''Print a success message to the console'''
        self.__print(message, Color.SUCCESS, verbose)

    def warn(self, message: str, verbose: str = ''):
        '''Print a warning message to the console'''
        self.__print(message, Color.WARN, verbose)

    def error(self, message: str, verbose: str = ''):
        '''Print an error message to the console'''
        self.__print(message, Color.ERROR, verbose)

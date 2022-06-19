
from enum import Enum
from termcolor import colored, cprint
from helpers import count_str_chars

class Color(Enum):
    '''Console output colors'''
    INFO = 'white'
    SUCCESS = 'green'
    WARN = 'yellow'
    ERROR = 'red'

class Console:
    '''Console helper'''

    DEFAULT_COLOR = Color.INFO.value

    def __init__(self, verbosity = ''):
        self.__verbosity = verbosity

    @property
    def verbosity(self):
        '''Get the configured verbosity level'''
        return self.__verbosity

    @verbosity.setter
    def verbosity(self, verbosity):
        '''Set how verbose the output should be [v,vv,vvv,vvvv]'''
        self.__verbosity = verbosity

    def print(self, message, color = DEFAULT_COLOR, verbose = ''):
        '''Print a message to the console'''
        if count_str_chars(verbose, 'v') <= count_str_chars(self.__verbosity, 'v'):
            cprint(colored(message, color))

    def info(self, message, verbose = ''):
        '''Print an info message to the console'''
        self.print(message, Color.INFO.value, verbose)

    def success(self, message, verbose = ''):
        '''Print a success message to the console'''
        self.print(message, Color.SUCCESS.value, verbose)

    def warn(self, message, verbose = ''):
        '''Print a warning message to the console'''
        self.print(message, Color.WARN.value, verbose)

    def error(self, message, verbose = ''):
        '''Print an error message to the console'''
        self.print(message, Color.ERROR.value, verbose)
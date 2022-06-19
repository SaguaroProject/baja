
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

    DEFAULT_COLOR = Color.INFO

    def __init__(self, verbosity: str = ''):
        self.__verbosity = verbosity

    @property
    def verbosity(self) -> str:
        '''Get the configured verbosity level'''
        return self.__verbosity

    @verbosity.setter
    def verbosity(self, verbosity: str):
        '''Set how verbose the output should be [v,vv,vvv,vvvv]'''
        self.__verbosity = verbosity

    def print(self, message: str, color: Color = DEFAULT_COLOR, verbose: str = ''):
        '''Print a message to the console'''
        if count_str_chars(verbose, 'v') <= count_str_chars(self.__verbosity, 'v'):
            cprint(colored(message, color.value))

    def info(self, message: str, verbose: str = ''):
        '''Print an info message to the console'''
        self.print(message, Color.INFO, verbose)

    def success(self, message: str, verbose: str = ''):
        '''Print a success message to the console'''
        self.print(message, Color.SUCCESS, verbose)

    def warn(self, message: str, verbose: str = ''):
        '''Print a warning message to the console'''
        self.print(message, Color.WARN, verbose)

    def error(self, message: str, verbose: str = ''):
        '''Print an error message to the console'''
        self.print(message, Color.ERROR, verbose)

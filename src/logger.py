'''Output logging utility'''

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

    def write(self, message: str, color: Color):
        '''Print a message to the terminal'''
        cprint(colored(message, color.value))

class Logger:
    '''Log helper'''

    DEFAULT_COLOR = Color.INFO

    def __init__(self, output: Output, verbosity: int = 0):
        self.__output = output
        self.__verbosity = verbosity

    def __log(self, message: str, color: Color = DEFAULT_COLOR, verbose: str = ''):
        '''Print a message to the console'''
        if count_str_chars(verbose, 'v') <= self.__verbosity:
            self.__output.write(message, color)

    @property
    def verbosity(self) -> int:
        '''Get the output verbosity'''
        return self.__verbosity

    @verbosity.setter
    def verbosity(self, verbosity: int):
        '''Set the output verbosity'''
        self.__verbosity = verbosity

    def info(self, message: str, verbose: str = ''):
        '''Log an info message'''
        self.__log(message, Color.INFO, verbose)

    def success(self, message: str, verbose: str = ''):
        '''Log a success message'''
        self.__log(message, Color.SUCCESS, verbose)

    def warn(self, message: str, verbose: str = ''):
        '''Log a warning message'''
        self.__log(message, Color.WARN, verbose)

    def error(self, message: str, verbose: str = ''):
        '''Log an error message'''
        self.__log(message, Color.ERROR, verbose)

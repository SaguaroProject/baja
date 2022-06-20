'''Controller and utilities for a command'''

from abc import ABC, abstractmethod
from logger import Logger
from system import System

class Command(ABC):
    '''Base controller class for a command'''

    def __init__(self, sys: System, log: Logger):
        self.__log = log
        self.__sys = sys
        self.__returncode = 0

    @property
    def log(self) -> Logger:
        '''Get the logger instance'''
        return self.__log

    @property
    def sys(self) -> System:
        '''Get the system instance'''
        return self.__sys

    @property
    def returncode(self) -> int:
        '''Get the return code'''
        return self.__returncode

    @returncode.setter
    def returncode(self, returncode) -> int:
        '''Set the return code'''
        self.__returncode = returncode

    @property
    @abstractmethod
    def help(self) -> str:
        '''Get the help text for the command'''

    @abstractmethod
    def handle(self):
        '''Handle the command'''

    def configure(self, parser) -> None:
        '''Configure additional options for the command'''

'''Controller and utilities for a command'''

from abc import ABC, abstractmethod
from logger import Logger

class Command(ABC):
    '''Base controller class for a command'''

    def __init__(self, log: Logger):
        self.__log = log

    @property
    def log(self) -> Logger:
        '''Get the logger instance'''
        return self.__log

    @property
    @abstractmethod
    def help(self) -> str:
        '''Get the help text for the command'''

    @abstractmethod
    def handle(self):
        '''Handle the command'''

    def configure(self, parser) -> None:
        '''Configure additional options for the command'''

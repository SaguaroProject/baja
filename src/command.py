'''Controller and utilities for a command'''

from abc import ABC, abstractmethod

class Command(ABC):
    '''Base controller class for a command'''

    @abstractmethod
    def handle(self):
        '''Handle the command'''

    @property
    @abstractmethod
    def help(self) -> str:
        '''Get the help text for the command'''

    def configure(self, parser) -> None:
        '''Configure additional options for the command'''

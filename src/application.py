'''The entrypoint of the application'''

import argparse

class Application:
    '''The application entrypoint'''

    def __init__(self, name: str, version: str):
        self.__name = name
        self.__version = version

        self.__parser = argparse.ArgumentParser()
        self.__subparser = self.__parser.add_subparsers(title='available commands')
        self.__parser.add_argument('--version', action='version', version=self.__name + ' ' + self.__version)
        self.__parser.set_defaults(func=lambda x, y: self.__parser.print_usage())

    @property
    def version(self) -> str:
        '''The application version'''
        return self.__version

    @property
    def name(self) -> str:
        '''The application name'''
        return self.__name

    def run(self) -> int:
        '''Start the application'''
        (args, extras) = self.__parser.parse_known_args()
        args.func(args, extras)

    def configure(self, func: callable) -> None:
        '''Additional configuration for the application'''
        func(self.__parser)

    def register_command(self, command: str, cls):
        '''Register a new command'''
        controller = cls()
        parser = self.__subparser.add_parser(command, help=controller.help)
        parser.set_defaults(func=controller.handle)
        controller.configure(parser)

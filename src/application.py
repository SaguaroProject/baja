'''The entrypoint of the application'''

import argparse
from logger import Logger, Output
from system import System

class Application:
    '''Application entrypoint'''

    def __init__(self, name: str, version: str):
        self.__name = name
        self.__version = version

        self.__parser = argparse.ArgumentParser()
        self.__subparser = self.__parser.add_subparsers(title='available commands')

        self.__log = Logger(Output())
        self.__sys = System()

        # Configure the command parser
        self.__configure_parser(self.__parser)

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
        self.__log.verbosity = -1 if args.quiet else args.verbosity
        args.controller.handle(vars(args), extras)

        return args.controller.returncode

    def register_command(self, command: str, cls):
        '''Register a new command'''
        controller = cls(self.__sys, self.__log)
        parser = self.__subparser.add_parser(command, help=controller.help)
        parser.set_defaults(controller=controller)
        controller.configure(parser)

    def __configure_parser(self, parser):
        '''Additional configuration for the application'''
        parser.add_argument('--version', action='version', version=self.__name + ' ' + self.__version)
        parser.set_defaults(func=lambda args, extras: self.__parser.print_usage())

        output_group = parser.add_mutually_exclusive_group()
        output_group.add_argument('-q', '--quiet', action='store_true', help='suppress all command output')
        output_group.add_argument('-v', '--verbose', dest='verbosity', default=0, action='count', help='increase output verbosity')

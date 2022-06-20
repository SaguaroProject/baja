import argparse
import os
import sys

from command import Command

class ExecCommand(Command):

    @property
    def help(self) -> str:
        return 'execute a command in a docker container'

    def configure(self, parser):
        parser.add_argument('container', help='the container to execute the command in')
        parser.add_argument('command', help='the command to execute', nargs=argparse.REMAINDER)

    def handle(self, args, extras):
        '''Handle the command'''
        print('in handle()')
        print(args)
        print(extras)

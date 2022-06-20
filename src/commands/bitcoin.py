import argparse
import os
import sys

from command import Command

class JsonRpcCommand(Command):

    @property
    def help(self) -> str:
        return 'execute a JSON-RPC command'

    def configure(self, parser):
        parser.add_argument('command', help='the RPC command to execute', nargs=argparse.REMAINDER)

    def handle(self, args, extras):
        '''Handle the command'''
        print('in handle()')
        print(args)
        print(extras)
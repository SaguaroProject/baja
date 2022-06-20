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
        print(args['command'])
        print(extras)
        self.log.error('this is a message', 'v')
        self.returncode = 1
        self.log.info(self.sys.run('ls /tmp'), 'v')

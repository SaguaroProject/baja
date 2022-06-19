import os
import sys

from unittest import TestCase

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

import system

class SystemTest(TestCase):
    '''Tests for system functions'''

    def test_run_return_zero(self):
        '''Test executing a command with a zero exit code'''
        command = 'echo "cat" && exit 0'
        (result, output) = system.run(command)

        self.assertEqual(result, 0)
        self.assertEqual(output, 'cat')

    def test_run_return_not_zero(self):
        '''Test executing a command with a non-zero exit code'''
        command = 'echo "oops" > /dev/stderr && exit 1'
        (result, output) = system.run(command)

        self.assertEqual(result, 1)
        self.assertEqual(output, 'oops')

    def test_run_empty_output(self):
        '''Test executing a command with no output'''
        command = 'exit 0'
        (result, output) = system.run(command)

        self.assertEqual(result, 0)
        self.assertEqual(output, '')

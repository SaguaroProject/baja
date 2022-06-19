import os
import sys

from unittest import TestCase
from unittest.mock import call, patch

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

from console import Color, Console

@patch('console.Output')
class ConsoleTest(TestCase):
    '''Tests for the console helper'''

    def test_output(self, mock_output):
        '''Test the console output and colors'''
        message = 'testing'
        console = Console(mock_output)

        console.info(message)
        console.warn(message)
        console.success(message)
        console.error(message)

        assert mock_output.print.mock_calls == [
            call(message, Color.INFO),
            call(message, Color.WARN),
            call(message, Color.SUCCESS),
            call(message, Color.ERROR)
        ]

    def test_verbose_output(self, mock_output):
        '''Test that output is printed in verbose mode'''
        console = Console(mock_output, 'v')
        message = 'testing'

        console.info(message)
        console.info(message, 'v')
        self.assertEqual(mock_output.print.call_count, 2)

    def test_output_is_surpressed(self, mock_output):
        '''Test that output is surpressed'''
        console = Console(mock_output)
        message = 'testing'

        console.info(message, 'v')
        console.info(message, 'vvvv')
        self.assertEqual(mock_output.print.call_count, 0)

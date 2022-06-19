import os
import sys

from unittest import TestCase
from unittest.mock import patch, call

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

from console import Color, Console

@patch('console.cprint')
@patch('console.colored')
class ConsoleTest(TestCase):
    '''Tests for the console helper'''

    def test_write(self, mock_cprint, _):
        '''Test that write() is called with the default color'''
        console = Console()
        console.print('test')

        assert mock_cprint.mock_calls == [call('test', Console.DEFAULT_COLOR.value)]

    def test_colors(self, mock_cprint, _):
        '''Test that helpers set the proper colors'''
        console = Console()
        message = 'testing'

        console.info(message)
        console.warn(message)
        console.success(message)
        console.error(message)

        assert mock_cprint.mock_calls == [
            call(message, Color.INFO.value),
            call(message, Color.WARN.value),
            call(message, Color.SUCCESS.value),
            call(message, Color.ERROR.value)
        ]

    def test_verbose_output(self, mock_cprint, _):
        '''Test that output is printed in verbose mode'''
        console = Console('v')
        message = 'testing'

        console.info(message, '')
        console.info(message, 'v')
        self.assertEqual(mock_cprint.call_count, 2)

    def test_output_surpressed(self, mock_cprint, _):
        '''Test that output is surpressed'''
        console = Console()
        message = 'testing'

        console.info(message, 'v')
        console.info(message, 'vvvv')
        self.assertEqual(mock_cprint.call_count, 0)

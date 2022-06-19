import os
import sys

from unittest import TestCase
from unittest.mock import call, patch

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

from logger import Color, Logger

@patch('logger.Output')
class LoggerTest(TestCase):
    '''Tests for the logger utility'''

    def test_output(self, mock_output):
        '''Test output and colors'''
        message = 'testing'
        log = Logger(mock_output)

        log.info(message)
        log.warn(message)
        log.success(message)
        log.error(message)

        assert mock_output.write.mock_calls == [
            call(message, Color.INFO),
            call(message, Color.WARN),
            call(message, Color.SUCCESS),
            call(message, Color.ERROR)
        ]

    def test_verbose_output(self, mock_output):
        '''Test that output is output in verbose mode'''
        message = 'testing'
        log = Logger(mock_output, 'v')

        log.info(message)
        log.info(message, 'v')
        self.assertEqual(mock_output.write.call_count, 2)

    def test_output_is_surpressed(self, mock_output):
        '''Test that output is surpressed'''
        message = 'testing'
        log = Logger(mock_output)


        log.info(message, 'v')
        log.info(message, 'vvvv')
        self.assertEqual(mock_output.write.call_count, 0)

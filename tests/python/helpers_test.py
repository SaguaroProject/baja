import os
import sys

from unittest import TestCase

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

import helpers

class HelpersTest(TestCase):
    '''Tests for helper functions'''

    def test_count_str_chars(self):
        '''Test counting the the instances of a character in a string'''
        string = 'The quick brown fox jumps over the lazy dog'

        self.assertEqual(helpers.count_str_chars(string, 's'), 1)
        self.assertEqual(helpers.count_str_chars(string, 'o'), 4)
        self.assertEqual(helpers.count_str_chars(string, ' '), 8)

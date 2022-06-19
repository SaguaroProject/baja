import os
import sys

from unittest import TestCase

# Append src to path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../src'))

import docker

class DockerTest(TestCase):
    '''Tests for docker functions'''

    def test_exec(self):
        '''Test that arguments are parsed correctly by exec'''
        self.assertEqual(docker.exec('container', ['testing', '--test']), "docker exec container testing --test")
        self.assertEqual(docker.exec('container', ['test', '"test"']), "docker exec container test \"test\"")

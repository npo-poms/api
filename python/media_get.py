#!/usr/bin/env python3
"""

"""
from npoapi.npoapi import Media
import sys


client = Media().configured_login(read_environment=True)

print(client.get(sys.argv[1]))

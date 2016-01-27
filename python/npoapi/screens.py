from .npoapi import NpoApi
import json


class Screens(NpoApi):
    def list(self, sort="asc", offset=0, max_=240):
        return self.http_get("/api/screens", params={"sort": sort, "offset": offset, "max": max_})


import unittest

ENV = "dev"


class ScreenTests(unittest.TestCase):
    def test_screens(self):
        client = Screens().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.list(offset=3))
        self.assertEqual(result["offset"], 3)

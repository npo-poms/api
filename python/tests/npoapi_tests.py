#!/usr/bin/env python3
from npoapi import *
import json
import unittest

ENV = "dev"


class Tests(unittest.TestCase):
    def test_authentication(self):
        client = npoapi.NpoApi(origin="http://www.vpro.nl") \
            .login(key="a", secret="b")
        self.assertEqual("NPO a:CtHYR9a+nr17OIn5rYml6a+A9ujqe0IywWqr93/DAOk=",
                         client.authenticate(uri="/media", now="Fri, 30 Oct 2015 08:43:31 -0000")[0])


class MediaTests(unittest.TestCase):
    def test_get(self):
        client = npoapi.Media().configured_login().env(ENV).debug()
        result = json.JSONDecoder().decode(client.get("AVRO_1656037"))
        self.assertEqual(result["mid"], "AVRO_1656037")

    def test_get_quote(self):
        client = Media().configured_login().env(ENV).debug()
        result = json.JSONDecoder().decode(client.get(" Avro_1260864"))
        self.assertEqual(result["mid"], " Avro_1260864")

    def test_list(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.list())
        ""

    def test_search(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.search("{}"))
        ""


class ScreenTests(unittest.TestCase):
    def test_screens(self):
        client = Screens().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.list(offset=3))
        self.assertEqual(result["offset"], 3)

def main():
    print("hoi")
    unittest.main()

from .npoapi import NpoApi
import urllib.request
import json


class Media(NpoApi):
    def get(self, mid):
        return self.http_get("/api/media/" + urllib.request.quote(mid))

    def list(self):
        return self.http_get("/api/media")

    def search(self, form="{}", sort="asc", offset=0, max_=240):
        return self.http_get("/api/media", data=form, params={"sort": sort, "offset": offset, "max": max_})



import unittest
ENV = "dev"

class MediaTests(unittest.TestCase):
    def test_get(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.get("AVRO_1656037"))
        self.assertEqual(result["mid"], "AVRO_1656037")

    def test_get_quote(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.get(" Avro_1260864"))
        self.assertEqual(result["mid"], " Avro_1260864")

    def test_list(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.list())
        print(result)

    def test_search(self):
        client = Media().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.search("{}"))
        print(result)

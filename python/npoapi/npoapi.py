__author__ = 'michiel'

import hmac, hashlib, base64
from email import utils
import urllib.request


class NpoApi:
    def __init__(self, key=None, secret=None, url="https://api.poms.omroep.nl/v1", origin=None, email=None):
        self.key, self.secret, self.url, self.origin, self.errors \
            = key, secret, url, origin, email


    def login(self, key, secret):
        self.key = key
        self.secret= secret
        return self

    def configured_login(self):
        import configparser
        import os

        config_file = os.path.join(os.path.dirname(__file__), "..", "..", "..", "creds.json")
        if not os.path.isfile(config_file):
            config_file = os.path.join(os.path.dirname(__file__),  "creds.json")

        with open(config_file) as data:
            json_data = json.load(data, strict = False)
            self.login(json_data["apikey"], json_data["secret"])
            if "origin" in json_data:
                self.origin = json_data["origin"]
        return self




    def authenticate(self, uri=None):
        now = utils.formatdate()
        message = "origin:" + self.origin + ",x-npo-date:" + now + ",uri:/v1/" + uri
        encoded = base64.b64encode(hmac.new(self.secret.encode('ascii'), msg=message.encode('ascii'), digestmod=hashlib.sha256).digest())
        return "NPO " + self.key + ":" + encoded.decode('ascii'), now

    def http_get(self, path, params=None):
        req = urllib.request.Request(self.url)
        authorization, date = self.authenticate(path)
        req.add_header("Authorization", authorization)
        req.add_header("X-NPO-Date", date)
        req.add_header("Origin", self.origin)
        req.add_header("Accept", "application/json")
        return urllib.request.urlopen(req).read()

    def get(self, mid):
        return self.http_get("api/media/" + mid)


import unittest

class Tests(unittest.TestCase):
    def test_authenication(self):
        npoapi = NpoApi(origin ="http://www.vpro.nl") \
            .login(key="a", secret="b")
        npoapi.email = 'michiel.meeuwissen@gmail.com'

        self.assertEqual("NPO ", npoapi.authenticate(uri = "/media/"))

    def test_get(self):
        npoapi = NpoApi().configured_login()

        npoapi.email, npoapi.origin = "michiel.meeuwissen@gmail.com", "http://www.vpro.nl"
        print(npoapi.get("AVRO_1656037"))

    def test_configured_login(self):
        npoapi = NpoApi().configured_login()
        npoapi.email, npoapi.origin = "michiel.meeuwissen@gmail.com", "http://www.vpro.nl"
        print(npoapi.authenticate(uri = "/media"))




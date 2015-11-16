__author__ = 'michiel'

import hmac, hashlib, base64
from email import utils
import urllib.request
import logging
import json
import xml.etree.ElementTree


class NpoApi:
    def __init__(self, key=None, secret=None, url="https://api.poms.omroep.nl/v1", origin=None, email=None):
        self.key, self.secret, self.url, self.origin, self.errors \
            = key, secret, url, origin, email


    def login(self, key, secret):
        self.key = key
        self.secret = secret
        return self

    def env(self, e):
        if e == "prod":
            self.url = "https://rs.poms.omroep.nl/v1"
        elif e == "test":
            self.url = "https://rs-test.poms.omroep.nl/v1"
        elif e == "dev":
            self.url = "http://rs-dev.poms.omroep.nl/v1"
        elif e == "localhost":
            self.url = "http://localhost:8070/v1"
        else:
            self.url = e
        return self

    def configured_login(self):
        """
        Logs in using configuration file. Considered using json (no comments-> unusable) or configparser (nearly properties, but heading are required..)
        So, now it simply parses the file itself.
        """
        import os

        config_files = [
            os.path.join(os.path.expanduser("~"), "conf", "creds.properties"),
            os.path.join(os.path.dirname(__file__), "..", "..", "..", "creds.properties"),
            os.path.join(os.path.dirname(__file__), "..", "..", "..", "creds.sh"),
            os.path.join(os.path.dirname(__file__), "creds.properties")]
        i = 0
        while not os.path.isfile(config_files[i]):
            i += 1

        config_file = os.path.normpath(config_files[i])
        logging.debug("Reading " + config_file)

        settings = {}
        with open(config_file, "rt") as f:
            for line in f:
                l = line.strip()
                if l and not l.startswith("#"):
                    key_value = l.split("=", 2)
                    settings[key_value[0].strip().lower()] = key_value[1].strip('" \t')
        logging.debug(str(settings))
        self.login(settings["apikey"], settings["secret"])
        if "origin" in settings:
            self.origin = settings["origin"]
        return self

    def authenticate(self, uri=None, now=utils.formatdate()):
        message = "origin:" + self.origin + ",x-npo-date:" + now + ",uri:/v1" + urllib.request.unquote(uri)
        logging.debug("message:" + message)
        encoded = base64.b64encode(
            hmac.new(self.secret.encode('utf-8'), msg=message.encode('utf-8'), digestmod=hashlib.sha256).digest())
        return "NPO " + self.key + ":" + encoded.decode('utf-8'), now

    def _get_url(self, path, params=None):
        if not params:
            params = {}

        path_for_authentication = path
        if params.items():
            sep = "?"
            for k, v in sorted(params.items()):
                path += sep + k + "=" + urllib.request.quote(str(v))
                path_for_authentication += "," + k + ":" + str(v)
                sep = "&"

        url = self.url + path
        return url, path_for_authentication

    def _authentication_headers(self, req, path_for_authentication):
        authorization, date = self.authenticate(path_for_authentication)
        req.add_header("Authorization", authorization)
        req.add_header("X-NPO-Date", date)
        req.add_header("Origin", self.origin)

        logging.debug(str(req.get_full_url()))

    @staticmethod
    def _get_data(data=None):
        if type(data) == str:
            try:
                json_object = json.JSONDecoder().decode(data)
                return json.JSONEncoder().encode(json_object).encode("UTF-8"), "application/json"
            except json.JSONDecodeError:
                return data.encode("UTF-8"), "application/xml"



        return None,None

    def http_get(self, path, params=None, accept="application/json", data=None):
        url, path_for_authentication = self._get_url(path, params)
        d, ct = self._get_data(data)
        req = urllib.request.Request(url, data=d)
        if ct:
            req.add_header("Content-Type", ct)

        self._authentication_headers(req, path_for_authentication)
        req.add_header("Accept", accept)
        return urllib.request.urlopen(req).read().decode('utf-8')


class Media(NpoApi):
    def get(self, mid):
        return self.http_get("/api/media/" + urllib.request.quote(mid))

    def list(self):
        return self.http_get("/api/media")

    def search(self, form="{}", sort="asc", offset=0, max_=240):
        return self.http_get("/api/media", data=form, params={"sort": sort, "offset": offset, "max": max_})


class Pages(NpoApi):
    def get(self, url):
        return self.http_get("/api/page/" + url)


class Screens(NpoApi):
    def list(self, sort="asc", offset=0, max_=240):
        return self.http_get("/api/screens", params={"sort": sort, "offset": offset, "max": max_})


import unittest

ENV = "dev"


class Tests(unittest.TestCase):

    def test_authentication(self):
        client = NpoApi(origin="http://www.vpro.nl") \
            .login(key="a", secret="b")
        self.assertEqual("NPO a:CtHYR9a+nr17OIn5rYml6a+A9ujqe0IywWqr93/DAOk=",
                         client.authenticate(uri="/media", now="Fri, 30 Oct 2015 08:43:31 -0000")[0])


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


class ScreenTests(unittest.TestCase):
    def test_screens(self):
        client = Screens().configured_login().env(ENV)
        result = json.JSONDecoder().decode(client.list(offset=3))
        self.assertEqual(result["offset"], 3)







from .npoapi import NpoApi


class Pages(NpoApi):
    def get(self, url):
        return self.http_get("/api/page/" + url)


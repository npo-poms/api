Examples for the [npo media api](https://rs.poms.omroep.nl/v1/docs/api/#!/media)

e.g.
```bash
    $ npo_media_search -e prod --properties title  search-member-clips.json | jq . | head -100
```
(uses [npo_media_search](https://github.com/npo-poms/pyapi/blob/master/bin/npo_media_search))

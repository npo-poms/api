NPO frontend API scripts
========================

PYTHON
======
Python scripts are maintained in https://github.com/npo-poms/pyapi

BASH
====

Credentials
===========
In the 'bash' directory you find a file 'creds-example.sh'. Copy this file to
'bash/creds.sh' (or '../creds.sh'), and edit it, it should contain your
apiKey and secret.

publish scripts
===============

There are bash scripts to show how to add your pages to the NPO frontend api in bash/publish.

```bash
michiel@baleno:~/github/npo-poms/api/bash/publish$ ./post.sh ../publish-examples/page-withembeds.xml
http://localhost:8060/api/pages/updates
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Set-Cookie: JSESSIONID=1BD4F5F3138649C537FB0F3000C73E23; Path=/; HttpOnly
Content-Type: application/json
Content-Length: 35
Date: Wed, 23 Jul 2014 08:05:19 GMT

36-e412b7bead650715ba72e4689b5706c2michiel@baleno:~/github/npo-poms/api/bash$
```

client scripts
==============

You can query the public api with a script like so:
```bash
michiel@baleno:~/github/npo-poms/api/bash$ ./media/search.sh ../../examples/media/broadcasters.json
{"total":623411,"offset":0,"max":2,"items":[{"score":5.0,"highlights":[],"result":{"objectType":"group","mid":"POMS_S_VPRO_157807","creationDate":1352295543264,"lastModified":1352295543579,"urn":"urn:vpro:media:group:16055794","embeddable":true,"broadcasters":[{"id":"VPRO","value":"VPRO"}],"titles":[{"value":"WOORD 27 oktober 2012: UUR 1","owner":"BROADCASTER","type":"MAIN"}],"descriptions":[{"value":"Het Radiohistorisch Amsterdam","owner":"BROADCASTER","type":"MAIN"}],"genres":[],"countries":[],"languages":[],"predictions":[{"state":"REALIZED","platform":"INTERNETVOD"}],"locations":[{"programUrl":"http://audio.omroep.nl/radio1/vpro/woord/20121027-02.mp3","avAttributes":{"avFileFormat":"MP3"},"creationDate":1352295543460,"lastModified":1352295543578,"workflow":"PUBLISHED","owner":"BROADCASTER","urn":"urn:vpro:media:location:16055798"}],"workflow":"PUBLISHED","type":"SERIES","isOrdered":true,"avType":"AUDIO"}},{"score":5.0,"highlights":[],"result":{"objectType":"group","mid":"POMS_S_NTR_470249","creationDate":1390232343068,"lastModified":1393580536315,"urn":"urn:vpro:media:group:35773765","embeddable":true,"broadcasters":[{"id":"NTR","value":"NTR"}],"titles":[{"value":"Dokter Corrie","owner":"BROADCASTER","type":"MAIN"},{"value":"Dokter Corrie ","owner":"BROADCASTER","type":"LEXICO"}],"descriptions":[{"value":"Dokter Corrie, hilarisch vertolkt door Martine Sandifort, praat met allerlei bekende Nederlanders over hoe zij de puberteit hebben ervaren. Elke vrijdag in het Schooltv-weekjournaal om 11:00 uur bij Zapp.","owner":"BROADCASTER","type":"MAIN"},{"value":"Dokter Corrie, hilarisch vertolkt door Martine Sandifort, praat met allerlei bekende Nederlanders over hoe zij de puberteit hebben ervaren. Elke vrijdag in het Schooltv-weekjournaal om 11:00 uur bij Zapp.","owner":"BROADCASTER","type":"SHORT"}],"genres":[{"id":"3.0.1.1","terms":["Jeugd"]}],"tags":["dokter","lichaam","pubertijd","SchoolTV"],"countries":[],"languages":[],"descendantOf":[{"midRef":"WO_NTR_479456","urnRef":"urn:vpro:media:program:36696799","type":"CLIP"},{"midRef":"WO_NTR_479458","urnRef":"urn:vpro:media:program:36696873","type":"CLIP"}],"memberOf":[{"midRef":"WO_NTR_479456","urnRef":"urn:vpro:media:program:36696799","type":"CLIP","index":1,"highlighted":false,"added":1392045882985},{"midRef":"WO_NTR_479458","urnRef":"urn:vpro:media:program:36696873","type":"CLIP","index":1,"highlighted":false,"added":1392721302269}],"ageRating":"12","websites":[{"value":"http://www.schooltv.nl/weekjournaal/"}],"locations":[{"programUrl":"http://cgi.omroep.nl/cgi-bin/streams?/ntr/schooltv/weekjournaal/video/WJCorrieGeraldine.wmv","avAttributes":{"bitrate":1000000,"avFileFormat":"WM"},"creationDate":1391676858971,"lastModified":1391676859133,"workflow":"PUBLISHED","owner":"BROADCASTER","urn":"urn:vpro:media:location:36686887"}],"images":[{"title":"dokter corrie schooltv","description":"copyright_Lilian_van_Rooij","imageUri":"urn:vpro:image:367113","height":1525,"width":2287,"creationDate":1390558544610,"lastModified":1390558544679,"workflow":"PUBLISHED","owner":"BROADCASTER","type":"PICTURE","highlighted":false,"urn":"urn:vpro:media:image:35995269"},{"title":"Dokter Corrie 2","description":"Dokter Corrie 2","imageUri":"urn:vpro:image:396081","height":140,"width":240,"creationDate":1391443689030,"lastModified":1391443691069,"workflow":"PUBLISHED","owner":"BROADCASTER","type":"PICTURE","highlighted":false,"urn":"urn:vpro:media:image:36505735"},{"title":"Dokter Corrie","description":"Dokter Corrie","imageUri":"urn:vpro:image:398472","height":140,"width":240,"creationDate":1391507789813,"lastModified":1391507789923,"workflow":"PUBLISHED","owner":"BROADCASTER","type":"PICTURE","highlighted":false,"urn":"urn:vpro:media:image:36566104"},{"title":"dokter corrie","description":"dokter corrie schooltv","imageUri":"urn:vpro:image:358612","height":3150,"width":4724,"creationDate":1390298345952,"lastModified":1390298346010,"workflow":"PUBLISHED","owner":"BROADCASTER","type":"PICTURE","highlighted":false,"urn":"urn:vpro:media:image:35806459"}],"workflow":"PUBLISHED","type":"SERIES","isOrdered":true,"avType":"VIDEO"}}]}

```

Scripts can also be symlinked, and can be prefixed with the
environment. Here I symlinked 'media/get.sh' to ~/bin/apimedia-get.sh.
```bash
michiel@baleno:~$ ENV=prod ~/bin/apimedia-get.sh POW_00722648 | jsonformat | head -5
{
  "objectType" : "program",
  "mid" : "POW_00722648",
  "creationDate" : 1387432091934,
  "lastModified" : 1389792202585,
michiel@baleno:~$
```

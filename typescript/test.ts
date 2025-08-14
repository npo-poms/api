import NpoApi from "./npoapi";

import dotenv from 'dotenv'
dotenv.config();


class Test {
    readonly  api = new NpoApi(
        process.env.NPOAPI_KEY ?? "UNSET",
        process.env.NPOAPI_SECRET ?? "UNSET",
        process.env.NPOAPI_ORIGIN ?? "UNSET",
        process.env.NPOAPI_BASE_URL ?? 'https://rs-test.poms.omroep.nl/v1/api/'
    );

    testGet() {
        this.api.get("AVRO_1656037", {properties: "ageRating,predictions"}).then(response => {
            console.log(response.data);
        }).catch(error => {
            console.error(error);
        });
    }

    testIterate(max:number =  1000000) {
        this.api.iterate({properties: "ageRating,predictions", max: String(max)},
    `<api:mediaForm  xmlns:api="urn:vpro:api:2013" xmlns:media="urn:vpro:media:2009">
    <api:searches>
      
    </api:searches>
</api:mediaForm>
`).then(response => {
            response.data.on('data', (chunk: Buffer) => {
                // Process each chunk
                console.log(chunk.toString());
            });
        }).catch(error => {
            console.error(error);
        });
    }
}

const test = new Test();
test.testGet();
test.testIterate(10);
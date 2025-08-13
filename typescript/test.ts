import {NpoApi} from './npoapi'

const api = new NpoApi( "metadataservices", "<fill in>", "https://npo.nl")

api.get("AVRO_1656037").then(response => {
    console.log(response.data);
}).catch(error => {
    console.error(error);
});
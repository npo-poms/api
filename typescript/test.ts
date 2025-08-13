import {NpoApi} from './npoapi'

import dotenv from 'dotenv'
dotenv.config();

const secret = process.env.NPOAPI_SECRET;
const key = process.env.NPOAPI_KEY;

const api = new NpoApi(key, secret, "https://npo.nl")

api.get("AVRO_1656037?properties=all").then(response => {
    console.log(response.data);
}).catch(error => {
    console.error(error);
});
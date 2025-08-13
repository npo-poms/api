import {NpoApi} from './npoapi'

import dotenv from 'dotenv'
dotenv.config();

const secret = process.env.NPOAPI_SECRET;
const key = process.env.NPOAPI_KEY;
const origin = process.env.NPOAPI_ORIGIN;


const api = new NpoApi(key, secret, origin);

api.get("AVRO_1656037?properties=ageRating").then(response => {
    console.log(response.data);
}).catch(error => {
    console.error(error);
});
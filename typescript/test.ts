import NpoApi from "./npoapi";

import dotenv from 'dotenv'
dotenv.config();

const secret: string = process.env.NPOAPI_SECRET;
const key: string  = process.env.NPOAPI_KEY;
const origin: string = process.env.NPOAPI_ORIGIN;

const api = new NpoApi(key, secret, origin);

api.iterate( {properties: "ageRating,predictions", max: "100"}, {
    searches: {
        type: 'BROADCAST',
        platform: [ 'INTERNETVOD', 'EXTRA' ]
    }
}).then(response => {
    console.log(response.data);
}).catch(error => {
    console.error(error);
});
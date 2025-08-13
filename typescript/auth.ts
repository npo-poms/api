
import axios from 'axios';
import CryptoJS from 'crypto-js';

export class NpoApi {


    constructor(private key: string,
                private secret:string,
                private origin: string,
                public base_url: string = "https://rs-test.poms.omroep.nl/v1/api/"
                ) {

    }
    public async get(mid : string): Promise<any> {
        let url = this.base_url + "media/" + mid;
        let headers = await this.autHeaders(url);
        return await axios.get(url, {headers});
    }

    private async getParameter(query: string): Promise<any> {

        if (query.length == 0) {
            return "";
        }
        let result = '';
        const sorted = [].sort.call(query.all(), (a, b) => a.key.localeCompare(b.key));
        for (p in sorted) {
            result += ',' + sorted[p].key + ':' + sorted[p].value;
        }

        return result;
    }

    private async autHeaders(url: string): Promise<any> {
        const u = new URL(url);

        const npoDate =  new Date().toUTCString();
        const queryMsg = await this.getParameter(u.search);
        const msg = `origin:${this.origin},x-npo-date:${npoDate},uri:${u.pathname}${queryMsg}`;
        const enc = CryptoJS.HmacSHA256(msg, this.secret).toString(CryptoJS.enc.Base64);


        const headers = {
            'Accept': 'application/json',
            'Origin': this.origin,
            'X-NPO-Date':  npoDate,
            'Authorization': `NPO ${this.key}:${enc}`
        };

        return headers;

    }

}



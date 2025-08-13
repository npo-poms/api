
import axios from 'axios';
import CryptoJS from 'crypto-js';

/**
 * NpoApi handles API requests to the NPO service.
 *
 * @param key - API key for authentication
 * @param secret - API secret for signing requests
 * @param origin - Origin header value
 * @param base_url - Base URL for API requests
 */
export class NpoApi {


    constructor(private key: string,
                private secret:string,
                private origin: string,
                public base_url: string = "https://rs-test.poms.omroep.nl/v1/api/"
                ) {

    }

    /**
     * Get one media object by mid
     */
    public async get(mid : string): Promise<any> {
        let url = this.base_url + "media/" + mid;
        let headers = await this.autHeaders(url);
        return await axios.get(url, {headers});
    }

    private async getParameter(query: URLSearchParams): Promise<any> {

        const entries = Array.from(query.entries());
        if (entries.length === 0) {
            return "";
        }
        // Sort by key alphabetically
        entries.sort((a, b) => a[0].localeCompare(b[0]));
        // Build result string
        let result = '';
        for (const [key, value] of entries) {
            result += `,${key}:${value}`;
        }
        return result;
    }

    private async autHeaders(url: string): Promise<any> {
        const u = new URL(url);

        const npoDate =  new Date().toUTCString();
        const queryMsg = await this.getParameter(u.searchParams);
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



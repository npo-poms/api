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
class NpoApi {
    constructor(private key: string,
                private secret: string,
                private origin: string,
                public base_url: string = "https://rs.poms.omroep.nl/v1/api/"
                ) {
    }

    /**
     * Get one media object by mid
     */
    public async get(mid : string, parameters:Record<string, string> = {}): Promise<any> {
        const url = this.constructUrl("media/" + mid, parameters);
        const headers =  this.authHeaders(url);
        headers['Accept'] = 'application/json';
        return axios.get(url.toString(), {headers});
    }

    public async iterate(parameters:Record<string, string> = {}, body = ""): Promise<any> {
        const url = this.constructUrl("media/iterate", parameters);
        const headers =  this.authHeaders(url);
        headers['Content-Type'] = 'application/xml';
        return axios.post(url.toString(), body, {
            headers,
            responseType: 'stream'
            }
        );
    }


    protected authHeaders(url: URL): Record<string, string> {
        const npoDate =  new Date().toUTCString();
        const queryMsg =  this.sortAndConcat(url.searchParams);
        const msg = `origin:${this.origin},x-npo-date:${npoDate},uri:${url.pathname}${queryMsg}`;
        const enc = CryptoJS.HmacSHA256(msg, this.secret).toString(CryptoJS.enc.Base64);
        return {
            'Origin': this.origin,
            'X-NPO-Date': npoDate,
            'Authorization': `NPO ${this.key}:${enc}`
        };
    }

    // utilities

    protected constructUrl(path: string, parameters:Record<string, string> = {}) : URL {
        let query = this.joinParameters(parameters);
        let url = this.base_url + path +  query;
        return new URL(url);
    }

    private joinParameters(parameters:Record<string, string> = {}): string {
        let result= Object.entries(parameters)
            .map(([key, value]) => `${key}=${value}`)
            .join('&');
        return result === "" ? "" : "?" + result;
    }
    private sortAndConcat(query: URLSearchParams): string {
        return Array.from(query.entries())
            .sort((a, b) => a[0].localeCompare(b[0]))
            .map(([key, value]) => `,${key}:${value}`)
            .join('');
    }


}
export default NpoApi;


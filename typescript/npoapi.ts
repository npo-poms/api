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
                private secret:string,
                private origin: string,
                public base_url: string = "https://rs.poms.omroep.nl/v1/api/"
                ) {
    }

    /**
     * Get one media object by mid
     */
    public async get(mid : string, parameters:Record<string, string> = {}): Promise<any> {
        let query = this.joinParameters(parameters);
        let url = this.base_url + "media/" + mid + query;
        let headers =  this.authHeaders(url);
        headers['Accept'] = 'application/json';
        return axios.get(url, {headers});
    }


   public async iterate( parameters:Record<string, string> = {}): Promise<any> {

        let query = this.joinParameters(parameters);
        let url = this.base_url + "media/iterate" +  query;
        let headers =  this.authHeaders(url);
        headers['Accept'] = 'application/json';
        return axios.post(url, {}, {headers});
    }

   private joinParameters(parameters:Record<string, string> = {}): string {
     let result= Object.entries(parameters)
            .map(([key, value]) => `${key}=${value}`)
            .join('&');
      return result === "" ? "" : "?" + result;
   }



   private authHeaders(url: string): Record<string, string> {
        const u = new URL(url);
        const npoDate =  new Date().toUTCString();
        const queryMsg =  this.sortAndConcat(u.searchParams);
        const msg = `origin:${this.origin},x-npo-date:${npoDate},uri:${u.pathname}${queryMsg}`;
        const enc = CryptoJS.HmacSHA256(msg, this.secret).toString(CryptoJS.enc.Base64);
        return {
            'Origin': this.origin,
            'X-NPO-Date': npoDate,
            'Authorization': `NPO ${this.key}:${enc}`
        };
    }
    private sortAndConcat(query: URLSearchParams): string {
        return Array.from(query.entries())
            .sort((a, b) => a[0].localeCompare(b[0]))
            .map(([key, value]) => `,${key}:${value}`)
            .join('');
    }

}
export default NpoApi;


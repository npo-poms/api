/**
 * Prerequisites
 *
 * Include CryptoJS.js from this repository
 * It's SHA-256 and base64 encoding are used for NPO front end API authentication
 * Original code can be found at https://code.google.com/archive/p/crypto-js/
 *
 * @param {String} apiVersion defaults to v1
 * @constructor
 */

var Auth = function ( apiVersion ) {

    this.API_VERSION = apiVersion || 'v1';

    this.X_NPO_DATE = 'x-npo-date';
    this.X_NPO_MID = 'x-npo-mid';
    this.X_NPO_URL = 'x-npo-url';

};

Auth.prototype = {

    getCredentials: function ( secret, headers, resourcePath ) {

        var location = document.location;
        var origin = location.origin || ( location.protocol + '//' + location.hostname + ( location.port ? ':' + location.port : '' ) ); //IE :(
        var data = 'origin:' + origin;

        [ this.X_NPO_DATE, this.X_NPO_MID, this.X_NPO_URL ].forEach( function ( header ) {
            if ( header in headers ) {
                data += ',' + header.toLowerCase() + ':' + headers[ header ];
            }
        } );

        if ( resourcePath ) {
            data += ',uri:/'+ this.API_VERSION +'/api/';
            data += resourcePath.split( '?' )[ 0 ];
            data += this.getParameters( resourcePath );
        }

        return CryptoJS.HmacSHA256( data, secret ).toString( CryptoJS.enc.Base64 );
    },


    getParameters: function ( resourcePath ) {
        var result = '';
        var hash = {};
        var hashKeys = [];
        var questionMark = resourcePath.indexOf( '?' );

        if ( questionMark >= 0 ) {

            var params = resourcePath.substring( questionMark + 1 ).split( '&' );
            var paramLength = params.length;

            for ( var i = 0; i < paramLength; i++ ) {
                var param = params[ i ].split( '=' );
                hash[ param[ 0 ] ] = param[ 1 ];
                hashKeys.push( param[ 0 ] );
            }

            hashKeys = hashKeys.sort();

            var hashKeyLength = hashKeys.length;

            for ( var j = 0; j < hashKeyLength; j++ ) {
                if ( hashKeys[ j ] !== 'iecomp' ) {
                    result += ',' + hashKeys[ j ] + ':' + hash[ hashKeys[ j ] ];
                }
            }
        }

        return result;
    },


    getAuthorization: function ( apiKey, secret, headers, resourcePath ) {
        return 'NPO ' + apiKey + ':' + this.getCredentials( secret, headers, resourcePath );
    }

};
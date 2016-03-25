# Accessing the NPO frontend API with JavaScript

This repository provides 2 mechanisms for accessing the NPO frontend API with JavaScript.


1.  A simple bare bones example using XMLHttpRequest with authentication and JSON results
2.  An NPO API client library abstracting the authentication and requests and returning JavaScript Domain Model objects

With the latter you get smart objects with easy access to properties like titles, descriptions, images
and their URL locations, etc.


## 1) Bare bones XMLHttpRequest 

### GET request

Below is an example of a simple GET request for a media item's descendants, including authentication.
When testing, be sure to replace the `API_KEY` and `API_SECRET` with your values.

```Javascript

/**
 * Prerequisites
 *
 * Include CryptoJS.js from this repository
 * It's SHA-256 and base64 encoding are used for NPO front end API authentication
 * Original code can be found at https://code.google.com/archive/p/crypto-js/
 *
 * Include the Auth.js class from this repository, which is a helper class to create
 * authenticated strings for the authorization header in your requests.
 *
 */
        
var API_KEY = 'your NPO API key';
var API_SECRET = 'your NPO API secret';

var auth = new Auth();
var request = new XMLHttpRequest();

var server = 'https://rs.poms.omroep.nl/v1/api/';
var resourcePath = 'media/POMS_S_VPRO_826834/descendants';
var options = {
    offset: 2,
    sort: 'desc'
};
var getOptionsAsQueryString = function ( options, encodeValues ) {

    var queryString = '';

    for ( var param in options) {
        
        if ( options.hasOwnProperty( param ) ) {
    
            if ( queryString.length ) {
                queryString += '&';
            } else {
                queryString += '?';
            }                
                
            queryString += param +'=';
            queryString += ( encodeValues ) ? encodeURIComponent( options[ param ] ) : options[ param ];
        }
    }
    
    return queryString;
};

request.open( 'GET', server + resourcePath + getOptionsAsQueryString( options, true ), true );

request.onload = function () {

    if ( request.status >= 200 && request.status < 400 ) {

        var data = JSON.parse( request.responseText );

        console.log( data );

    } else {
        throw new Error( 'server reached, but returned an error' );
    }
};

request.onerror = function () {
    throw new Error( 'There was a server connection error' );
};


/* Authentication */

var headers = {};

headers[ 'x-npo-date' ] = new Date().toUTCString();
headers[ 'authorization' ] = auth.getAuthorization( API_KEY, API_SECRET, headers, resourcePath + getOptionsAsQueryString( options, false ) );

// keep this one here, should not be part of the headers used in auth.getAuthorization
headers[ 'Accept' ] = 'application/json, */*';

for ( var key in headers ) {

    if ( headers.hasOwnProperty( key ) ) {
        request.setRequestHeader( key, headers[ key ] );
    }
}

/* Ok Go! */

request.send();

```

### POST request

..TODO.. will follow as soon as possible

## 2) NPO JavaScript client library

..TODO.. will follow as soon as possible
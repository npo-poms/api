# Accessing the NPO frontend API with JavaScript

This repository provides 2 mechanisms for accessing the NPO frontend API with JavaScript.


1.  A simple bare bones example using XMLHttpRequest with authentication and JSON results
2.  An NPO API client library abstracting the authentication and requests and returning JavaScript Domain Model objects

With the latter you get smart objects with easy access to properties like titles, descriptions, images
and their URL locations, etc.


## 1) Bare bones XMLHttpRequest 

Basic information on authorization and GET / POST requests on the NPO frontend API can be found in the 
[NPO API Wiki](http://wiki.publiekeomroep.nl/display/npoapi/Algemeen)

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
var params = {
    offset: 2,
    sort: 'desc'
};

var getParamsAsQueryString = function ( params, encodeValues ) {

    var queryString = '';

    for ( var param in params) {
        
        if ( params.hasOwnProperty( param ) ) {
    
            if ( queryString.length ) {
                queryString += '&';
            } else {
                queryString += '?';
            }                
                
            queryString += param +'=';
            queryString += ( encodeValues ) ? encodeURIComponent( params[ param ] ) : params[ param ];
        }
    }
    
    return queryString;
};

request.open( 'GET', server + resourcePath + getParamsAsQueryString( params, true ), true );

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


/* Authentication and headers */

var headers = {};

headers[ 'x-npo-date' ] = new Date().toUTCString();
headers[ 'authorization' ] = auth.getAuthorization( API_KEY, API_SECRET, headers, resourcePath + getParamsAsQueryString( params, false ) );

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

Below is a simple POST request to search for media through the `/media` endpoint of the NPO API.
When testing, be sure to replace the API_KEY and API_SECRET with your values.

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
var resourcePath = 'media';
var params = {
    profile: 'vpro',
    properties: 'images,descriptions'
};
var searchForm = {
    searches : {
        text : {
            value : 'Tegenlicht'
        }
    }
};

var getParamsAsQueryString = function ( params, encodeValues ) {

    var queryString = '';

    for ( var param in params) {

        if ( params.hasOwnProperty( param ) ) {

            if ( queryString.length ) {
                queryString += '&';
            } else {
                queryString += '?';
            }

            queryString += param +'=';
            queryString += ( encodeValues ) ? encodeURIComponent( params[ param ] ) : params[ param ];
        }
    }

    return queryString;
};

request.open( 'POST', server + resourcePath + getParamsAsQueryString( params, true ), true );

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


/* Authentication and headers */

var headers = {};

headers[ 'x-npo-date' ] = new Date().toUTCString();
headers[ 'authorization' ] = auth.getAuthorization( API_KEY, API_SECRET, headers, resourcePath + getParamsAsQueryString( params, false ) );

// keep these ones here, should not be part of the headers used in auth.getAuthorization
headers[ 'Accept' ] = 'application/json, */*';
headers[ 'Content-Type' ] = 'application/json';

for ( var key in headers ) {

    if ( headers.hasOwnProperty( key ) ) {
        request.setRequestHeader( key, headers[ key ] );
    }
}

/* Ok Go! */

request.send( JSON.stringify( searchForm ) );

```


## 2) NPO JavaScript client library

..TODO.. will follow as soon as possible
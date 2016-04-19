# Accessing the NPO frontend API with JavaScript

This repository provides 2 mechanisms for accessing the NPO frontend API with JavaScript.


1.  A simple bare bones example using XMLHttpRequest with authentication and JSON results
2.  An [NPO API client](#2-npo-javascript-client-library) library abstracting the authentication and requests and returning JavaScript Domain Model objects

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

The NPO JavaScript client library is a standalone [UMD](https://github.com/umdjs/umd) library.
You only need to include jQuery, provide a window.NpoApiConfig variable and include  
`library/npoapi.library.js`, in that preferred order.


### Api configuration
With the NpoApiConfig variable you can easily configure the API's settings in
the preferred way and it can contain the following settings:

```javascript

var NpoApiConfig = {

    imageServer: 'POMS Image Server', // example: http://images.poms.omroep.nl/image/ 
                                      // (note the trailing slash)
    
    npoApiServer: 'NPO API Server', // example: https://rs.poms.omroep.nl
        
    npoApiKey: '{your NPO API key}',
        
    npoApiSecret: '{your NPO API secret}'    
};

```

Only the `imageServer` variable actually needs to be configured this way. And only if you
want to make use of the client library's capability to create URLs to POMS images
with custom image sizes.
 
The other 3 npo prefixed ones can also be passed on in the constructor of each available
service mentioned in the next chapter.

### Api usage

The NpoApi exposes the following variables:

-   MediaService - client library for NPO API's media endpoint
-   PageService - client library for NPO API's pages endpoint
-   ScheduleService - client library for NPO API's schedule endpoint
-   domain
    -   media - Domain Model classes returned / used by the MediaService
    -   pages - Domain Model classes returned / used by the PageService
    -   shared - Domain Model classes returned / used by all services    
-   MediaForm - Create a media search form needed in POST calls to the media endpoint
-   PageForm - Create a page search form needed in POST calls to the pages endpoint
    
All services are documented at [library/docs](library/docs/index.html) (view in a browser),
all domain model classes a level deeper in folders with their respective name, but below
some examples.

To be able to communicate with the API through JavaScript you need to access your 
(test)pages on a white-listed domain, like *.npo.nl.
    
#### MediaService

The MediaService provides access to the NPO API's media endpoint. You can get / list
media or search for it. The returned media objects are full-fledged group, program and
segment domain models of which you can discover their full power in the 
domain model docs [library/docs/media](library/docs/media/index.html).

##### Get example
```javascript

var mediaService = new NpoApi.MediaService(); // taking API configuration from the NpoApiConfig
// or
var mediaService = new NpoApi.MediaService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

    // note, most API methods return a (jQuery) Promise (http://api.jquery.com/deferred.promise/)
mediaService.load( 'VPWON_1223392' ).then(
    function ( mediaObject ) {
        // in this case, mediaObject is an instance of Program (library/docs/media/Program.html)
        
        var episodeTitle =  mediaObject.getSubTitle(); // returns the POMS episode title 
                            // or falls back to the first title of type SUB
        
        console.log( episodeTitle );
                            
        var sortDate = mediaObject.getSortDate(); // returns a FormatDate (library/docs/shared/FormatDate.html)
                                                           
        console.log( sortDate.toLocaleString('d MMMM, yyyy') ); // outputs 1 januari, 2015      
                                            
        var tvShows = mediaObject.getScheduleEvents(); // returns a list of ScheduleEvents (library/docs/media/ScheduleEvent.html)    
                                        
        mediaObject.getImages().forEach( function ( image ) {
            
            console.log( image.getLocation( 500, 200 ) ); 
                // needs the NpoApiConfig.imageServer property to be set
        });                                     
    }
)

```
    
##### Search example

Extensive documentation on media search capabilities of the API (and usage in the forms below) can
be found on the [NPO Wiki]( http://wiki.publiekeomroep.nl/display/npoapi/Media-+en+gids-API )

```javascript

var mediaService = new NpoApi.MediaService(); // taking API configuration from the NpoApiConfig
// or
var mediaService = new NpoApi.MediaService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

// there is an instantiable MediaForm object available on the NpoApi variable,
// but it's modestly documented, so you can also use an object with a toJSON function instead
var mediaForm = {   
    toJSON: function () {
        return {
            highlight: true,
            searches : {
                text : {
                    value : 'Nieuws'
                }
            }        
        };
    }
};    
    
mediaService.find( mediaForm ).then(
        
        // returns a MediaSearchResult (library/docs/MediaSearchResult.html
    function ( mediaSearchResult ) {
    
        console.log( 'found: '+ mediaSearchResult.getTotal() );
    
            // a searchResultItem (library/docs/SearchResultItem) contains 
            // data on the search results' score, and optional highlights
            // (in which media fields was the searched for term found)      
        mediaSearchResult.getList().forEach( function ( searchResultItem ) {
            
            var mediaObject = searchResultItem.getResult();
            
            console.log( mediaObject instanceof NpoApi.domain.media.Program );
            
            console.log( mediaObject.getObjectType() );                        
        });
    }
);    
    
```    

#### PageService
    
The PageService provides access to the NPO API's pages endpoint. You can get / list
pages or search for them. The returned page objects' full power can be found in the 
domain model docs [library/docs/media](library/docs/pages/index.html).    
    
    
##### Get example    
```javascript

var pageService = new NpoApi.PageService(); // taking API configuration from the NpoApiConfig
// or
var pageService = new NpoApi.PageService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

    // note, most API methods return a (jQuery) Promise (http://api.jquery.com/deferred.promise/)
pageService.suggest( {
        input: 'ba',
        profile: 'vpro',
        max: 20
    } ).then(
    
    function ( suggestions ) {
        suggestions.items.forEach(
            function ( suggestion ) {
                console.log( suggestion.text );
            }
        );                                 
    }
)

```
    
##### Search example

Extensive documentation on search capabilities of the pages API (and usage in the forms below) can
be found on the [NPO Wiki]( http://wiki.publiekeomroep.nl/display/npoapi/Page+API )

```javascript

var pageService = new NpoApi.PageService(); // taking API configuration from the NpoApiConfig
// or
var pageService = new NpoApi.PageService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

// there is an instantiable PageForm object available on the NpoApi variable,
// but it's modestly documented, so you can also use an object with a toJSON function instead
var pageForm = {   
    toJSON: function () {
        return {            
            facets: {
                sortDates: [
                    'LAST_WEEK', 'LAST_YEAR', 'BEFORE_LAST_YEAR'
                ]
            },
            highlight: true,
            searches: {
                text: 'Tegenlicht',
                types: [
                    'ARTICLE'
                ]
            }                  
        };
    }
};    
    
pageService.find( pageForm ).then(
        
        // returns a PageSearchResult (library/docs/PageSearchResult.html
    function ( pageSearchResult ) {
    
        console.log( 'found: '+ pageSearchResult.getTotal() );
    
            // a searchResultItem (library/docs/SearchResultItem) contains 
            // data on the search results' score, and optional highlights
            // (in which page fields was the searched for term found)      
        pageSearchResult.getList().forEach( function ( searchResultItem ) {
            
            var page = searchResultItem.getResult();
          
            console.log( NpoApi.domain.pages.PageType.displayNameForValue( page.getType() ) );
        });
    }
);    
    
```      
    
#### ScheduleService

The ScheduleService provides access to the NPO API's schedule endpoint.

##### Get example    
```javascript

var scheduleService = new NpoApi.ScheduleService(); // taking API configuration from the NpoApiConfig
// or
var scheduleService = new NpoApi.ScheduleService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

    // note, most API methods return a (jQuery) Promise (http://api.jquery.com/deferred.promise/)
scheduleService.getNextForChannel( 'NED1' ).then(
    
    function ( scheduleEvent ) {
        console.log( scheduleEvent.getStart().toLocaleString('dd-MM-yyyy hh:mm') );   
                                          
        console.log( scheduleEvent.getMediaObject().getMainTitle() );
    }
)

```
    
##### Search example 
   
Extensive documentation on schedule search capabilities of the API (and usage in the forms below) can
be found on the [NPO Wiki]( http://wiki.publiekeomroep.nl/display/npoapi/Media-+en+gids-API )   

    
```javascript

var scheduleService = new NpoApi.ScheduleService(); // taking API configuration from the NpoApiConfig
// or
var scheduleService = new NpoApi.ScheduleService( 'https://rs.poms.omroep.nl', 'NPO API key', 'NPO API secret' );

// The form sent with a ScheduleService search request actually consists of a MediaSearch
// so you can use a MediaForm.
// There is an instantiable MediaForm object available on the NpoApi variable,
// but it's modestly documented, so you can also use an object with a toJSON function instead
var mediaForm = {   
    toJSON: function () {
        return {
            searches : {
                text : {
                    value : 'Nieuws'
                }
            }        
        };
    }
};    
    
scheduleService.find( mediaForm ).then(
        
        // returns a PagedSearchResult (library/docs/PagedSearchResult.html
    function ( pagedSearchResult ) {
    
        console.log( 'found: '+ pagedSearchResult.getTotal() );
    
            // a searchResultItem (library/docs/SearchResultItem) contains 
            // data on the search results' score, and optional highlights
            // (in which media fields was the searched for term found)      
        pagedSearchResult.getList().forEach( function ( searchResultItem ) {
            
            var scheduleEvent = searchResultItem.getResult();
            
            console.log( scheduleEvent.getStart().toLocaleString('dd-MM-yyyy hh:mm') );   
                                              
            console.log( scheduleEvent.getMediaObject().getMainTitle() );                     
        });
    }
);    

```    
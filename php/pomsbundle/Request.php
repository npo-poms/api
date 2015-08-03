<?php

namespace Ntr\PomsBundle\Poms;
include 'exception/InvalidResponseException.php';

/***************************************************************
 *  Copyright notice
 *
 *  (c) 2014 Pierre van Rooden <pierre.van.rooden@ntr.nl>, NTR
 *
 *  All rights reserved
 *
 *  Written with tax-payers money. Just sayin'. Henceforth...
 *
 *  This is free software; You can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  The GNU General Public License can be found at
 *  http://www.gnu.org/copyleft/gpl.html.
 *
 *  This script is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  This copyright notice MUST APPEAR in all copies of the script!
 ***************************************************************/

/**
 * Class for querying the NPO API.
 * Handles the api security, and transforms returned (json) data as nested arrays.
 *
 * @package ntr_poms
 * @license http://www.gnu.org/licenses/gpl.html GNU General Public License, version 3 or later
 */

class Request {

	/**
	 * The operation to execute. This is the last part of the NPO API url path.
	 * Examples are:
	 * <ul>
	 * 	<li>media
	 * 	<li>media/multiple
	 * 	<li>media/POMS_S_NTR_607590/descendants
	 * 	<li>schedule/broadcaster/NTR/next
	 * </ul>
	 *
	 * @var string
	 */
	protected $operation;

	/**
	 * The name fo the profile to use.
	 * This is passed with a request to filter the output.
	 *
	 * @var string
	 */
	protected $profile;

	/**
	 * A body (i.e. a searchform) to pass with a POST request to filter the output.
	 *
	 * @var array
	 */
	protected $body;

	/**
	 * The GET parameters
	 * @var array
	 */
	protected $parameters = array();

	/**
	 * Settings.
	 * An array with key-value pairs for configuration.
	 * The settings expected are:
	 *
	 * npo_api_url, default http://rs-test.poms.omroep.nl:80
	 * npo_api_base_path, default: /v1/api/
	 * request_timeout, default. 5000
	 * npo_api_key, request at the NPO service desk
	 * npo_api_secret, request at the NPO service desk
	 * npo_api_origin, i.e http://www.ntr.nl (pass ot the service desk when requesting the apikey/secret)
	 *
	 * @var array
	 */
	protected $settings = array(
			'npo_api_url' => 'http://rs-test.poms.omroep.nl:80',
			'npo_api_base_path'=> '/v1/api/',
	 		'request_timeout' => 5000
		);

    /**
     * Constructor.
     * The passed settings array should include at least the values for the npo_api_key, npo_api_secret and npo_api_origin.
     *
     * @param  array  $settings Configuration
     * @return void
     **/
    public function __construct($settings) {
        $this->settings = array_merge($this->settings, $settings);
    }

	/**
	 * Returns the base url (domain name) for the NPO API.
	 *
	 * @return string
	 */
	public function getBaseUrl() {
		return $this->settings['npo_api_url'];
	}

	/**
	 * Returns the base path (the part of the url path before the operation) for the NPO API.
	 *
	 * @return string
	 */
	public function getBasePath() {
		return $this->settings['npo_api_base_path'];
	}

	/**
	 * Get the headers for the request
	 * This includes the authorization headers and the Accept header to request data in Json format.
	 *
	 * @return string The headers for the request
	 */
	public function getHeaders() {
		// obtain NPO API security settings
		$apiKey = $this->settings['npo_api_key'];
		$secret = $this->settings['npo_api_secret'];
		$origin = $this->settings['npo_api_origin'];
		// determine date
		$npoDate = str_replace ('+0000','GMT',gmdate(DATE_RFC822, time()));
		// Obtain parameters passed, and put these in alphabetic order
		$parameters = $this->getUrlParameters();
		$body = $this->getBody();
		if ($body) {
			// HOW To add body to the hash?
			// $parameters['body'] = json_encode($body);
			// $parameters = array_merge($parameters,$body);
		}

		$parameterString = "";
		if ($parameters) {
			ksort($parameters);
			foreach ($parameters as $key => $value) {
				if ($value !== null) {
					$parameterString .= ",".$key.":".$value;
				}
			}
		}
		// Construct the message to be encrypted as part of the authorization,
		// and hash this using hmac sha256
		$msg = "origin:".$origin.
			",x-npo-date:".$npoDate.
			",uri:".$this->getBasePath().$this->getOperation().$parameterString;
		$hash = base64_encode( hash_hmac ("sha256", $msg, $secret, true) );
		// construct and return headers
		return array(
			"Accept: application/json",    // this needs to be set in order to receive Json - otherwise the NPO API returns XML
			"Content-type: application/json",
			"Origin: ".$origin,
			"X-NPO-Date: ".$npoDate,
			"Authorization: NPO ".$apiKey.":". $hash
		);
	}

	/**
	 * Set the url operation, i.e. media, schedule/broadcaster/NTR/next, etc.
	 *
	 * @param string $operation
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function setOperation($operation) {
		$this->operation = $operation;
		return $this;
	}

	/**
	 * Get the url path
	 *
	 * @return string
	 */
	public function getOperation() {
		return $this->operation;
	}

	/**
	 * Set the name of the profile to use.
	 *
	 * @param string $profile
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function setProfile($profile) {
		$this->profile = $profile;
		return $this;
	}

	/**
	 * Get the name of the profile to use.
	 *
	 * @return string
	 */
	public function getProfile() {
		return $this->profile;
	}

	/**
	 * Set the body used in POST requests.
	 *
	 * @param array $body
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function setBody($body) {
		$this->body = $body;
		return $this;
	}

	/**
	 * Get the body used in POST requests.
	 *
	 * @return array
	 */
	public function getBody() {
		return $this->body;
	}

	/**
	 * Return the full url to fetch.
	 *
	 * @return string
	 */
	public function getUrl() {
		$url = $this->getBaseUrl().$this->getBasePath().$this->getOperation();
		$params = http_build_query($this->getUrlParameters());
		if ($params) {
			$url .= '?'.$params;
		}
		return $url;
	}

	/**
	 * Set the parameters
	 *
	 * @param array $parameters
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function setParameters($parameters) {
		$this->parameters = $parameters;
		return $this;
	}

	/**
	 * Return the rqeuest parameters.
	 *
	 * @return array
	 */
	public function getParameters() {
		return $this->parameters;
	}

	/**
	 * Return all parameters, including the profile if given.
	 *
	 * @return array
	 */
	public function getUrlParameters() {
		$parameters = $this->parameters;
		if ($this->profile) {
			$parameters['profile'] = $this->profile;
		}
		return $parameters;
	}

	/**
	 * Add a parameter
	 *
	 * @param string $key
	 * @param string $value
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function addParameter($key, $value) {
		$this->parameters[$key] = $value;
		return $this;
	}

	/**
	 * Remove a GET parameter
	 *
	 * @param  string $key
	 * @return \Ntr\PomsBundle\Poms\Request
	 */
	public function removeParameter($key) {
		unset($this->parameters[$key]);
		return $this;
	}

	/**
	 * Execute the GET request.
	 * This requires at least the operation to be set.
	 *
	 * @param $post if true, run the operation as a POST request
	 * @throws \Ntr\PomsBundle\Poms\Exception\InvalidResponseException
	 * @return string The response of the request, or false if no data was available
	 */
	public function execute($post = False) {
		$result = false;
    	$url =$this->getUrl();
		$ch = curl_init();
		curl_setopt_array($ch, array(
        	CURLOPT_URL => $url,
			CURLOPT_TIMEOUT => $this->settings['request_timeout'],
			CURLOPT_HTTPHEADER => $this->getHeaders(),
			CURLINFO_HEADER_OUT => true,
        	CURLOPT_POST => $post,
		));

		// Optionally add a body to a POST request
		$jsonBody = '';
		if ($post) {
			$body = $this->getBody();
			if ($body) {
				curl_setopt($ch,CURLOPT_POSTFIELDS, json_encode($body));
			}
		}

        ob_start();
        curl_exec($ch);
        $dataResult = ob_get_clean();

		$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		$curl_error = curl_error($ch);
		curl_close($ch);

		if($status == 404) {
			// no data found.
			// Do not treat this as an error (i.e. do not log), as it is a valid response, instead just return false
            return false;
		} else if($dataResult === False || $status != 200) {
            throw new \Ntr\PomsBundle\Poms\Exception\InvalidResponseException('NPO API cURL call failed for URL: ' . $url . ' error: ' . $curl_error . ' status return: ' . $status . ' return data: ' . $dataResult . ' in ' . __FILE__ . '@' . __LINE__);
		} else {
			$result = json_decode($dataResult, True);
			if(!is_array($result)) {
				throw new \Ntr\PomsBundle\Poms\Exception\InvalidResponseException('Response for URL: ' . $url . ': "'.$dataResult.'" is invalid JSON', $this->siteId);
			}
		}
		return $result;
	}

	/**
	 * Execute a GET request.
	 *
	 * @throws \Ntr\PomsBundle\Poms\Exception\InvalidResponseException
	 * @return string The response of the request, or false if no data was available
	 */
	public function get() {
		return $this->execute(false);
	}

	/**
	 * Execute a POST request.
	 *
	 * @throws \Ntr\PomsBundle\Poms\Exception\InvalidResponseException
	 * @return string The response of the request, or false if no data was available
	 */
	public function post() {
		return $this->execute(true);
	}

}

?>

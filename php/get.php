#!/usr/bin/env php
<?php
include 'pomsbundle/Request.php';
include '../../creds.php';


$request = new Ntr\PomsBundle\Poms\Request(array(
                                                 'npo_api_key' => $apiKey,
                                                 'npo_api_secret' => $secret,
                                                 'npo_api_origin' => $origin));

$result = $request->setOperation('media/' . $argv[1])->get();
echo json_encode($result);
?>
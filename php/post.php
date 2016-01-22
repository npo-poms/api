#!/usr/bin/env php
<?php
include 'pomsbundle/Request.php';
include '../../creds.php';

$request = new Ntr\PomsBundle\Poms\Request(array(
                                                 'npo_api_key' => $apiKey,
                                                 'npo_api_secret' => $secret,
                                                 'npo_api_origin' => $origin));

$file = $argv[1];
$body = file_get_contents($file);
$result = $request->setOperation('media')->setBody($body, False)->addParameter("offset", 0)->addParameter("max", 10)->post();
echo json_encode($result);
?>

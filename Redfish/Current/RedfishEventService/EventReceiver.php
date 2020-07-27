<?php
// Version 0.9999
/** This PHP script receives RESTful POST events from an iLO or a Superdome Flex RMC.
*   It reformats the JSON message with indentations and sends
*   it to a file in the current directory
**/

/* 
* The JSON format functions.php comes from:
* https://github.com/GerHobbelt/nicejson-php
*/
include 'functions.php';

// iLO events will be written to $out_file
$out_file = "Redfish_events.txt" ;

// Read the Content of the POST message:
$body = file_get_contents("php://input");


// Read the headers values:
$headers = getallheaders() ;

// Get IP address of managed node
$IP_MANAGED = getenv ('REMOTE_ADDR') ;


// Write IP_MANAGED in $outfile:
file_put_contents($out_file, "IP Address of Managed node: $IP_MANAGED \n", FILE_APPEND) ;

// Display headers and values
foreach ($headers as $header => $value) {
    file_put_contents($out_file, "$header: $value \n", FILE_APPEND) ;
}

//Insert new line to separate headers from body
file_put_contents($out_file, "\n", FILE_APPEND);


// Format message in nice and human readable format
file_put_contents($out_file, json_format($body) . "\n\n", FILE_APPEND);

?>

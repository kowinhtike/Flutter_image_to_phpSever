<?php

$return["error"] = false;
$return["msg"] = "";
//for html form use enctype="multipart/form-data" 
if(isset($_FILES['file']['name'])){
$file = $_FILES['file']['name'];
$file_loc = $_FILES['file']['tmp_name'];
$folder = "upload/";
$new_file_name = strtolower($file);
$randfile = rand(1000,100000).'_'.$new_file_name;
$final_file = str_replace('','-',$randfile);
//echo("Successful " . "$final_file");
move_uploaded_file($file_loc,$folder.$final_file);

}else if(isset($_POST["file"])){
    //this is for flutter
    $base64_string = $_POST["file"];
    $outputfile = "upload/image.jpg" ;
    $filehandler = fopen($outputfile, 'wb' ); 
    fwrite($filehandler, base64_decode($base64_string));
    fclose($filehandler); 
}else{
    $return["error"] = true;
    $return["msg"] =  "No image is submited.";
}

header('Content-Type: application/json');
echo json_encode($return);

?>

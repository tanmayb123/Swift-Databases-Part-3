<?php
 
$target_path = "itemIMG/";  //where you want the uploaded images to go, I recommend an upload only directory
$target_path = $target_path . basename( $_FILES['userfile']['name'] );
 
if(move_uploaded_file($_FILES['userfile']['tmp_name'], $target_path)) {
 
//successful move
} else {
 
//unsuccessful move
}
?>

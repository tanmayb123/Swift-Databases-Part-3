<?php
$host = "localhost"; //database host server
$db = "itemReg"; //database name
$user = "itemRegistry"; //database user
$pass = "PASSWORD"; //password

$connection = mysql_connect($host, $user, $pass);

//Check to see if we can connect to the server
if(!$connection)
{
    die("Database server connection failed.");  
}
else
{
    //Attempt to select the database
    $dbconnect = mysql_select_db("itemReg", $connection);

    //Check to see if we could select the database
    if(!$dbconnect)
    {
        die("Unable to connect to the specified database!");
    }
    else
    {
        $query = "INSERT INTO `itemReg`.`items` (`friend`, `item`, `img`) VALUES ('" . $_GET['x'] . "', '" . $_GET['y'] . "', '" . $_GET['b'] . "');";
        $resultset = mysql_query($query, $connection);

        echo "Successfully added ";
        echo $query;

    }


}


?>

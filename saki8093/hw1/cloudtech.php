<?php
$servername = "172.28.3.100";
$username = "admin";
$password = "secret";
$dbname = "anime";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}
$query = mysqli_query($conn,"SELECT * FROM anime")
        or die (mysqli_fetch_error($query));

echo "<html> 
	<title>  Cloud Tech </title>
	<h1> A simple PHP webserver and MySQL server infrastructure deployed on AWS by terraform </h1>";


while ($row = mysqli_fetch_array($query)) {
        echo $row['Name'] ;
	echo $row['Powerlevel'];
	echo "<br>";
}
?>

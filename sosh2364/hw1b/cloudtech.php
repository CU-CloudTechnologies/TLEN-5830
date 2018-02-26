<?php
# NOTE: using hard coded IP here, should change to variable from tf output
$servername = "10.0.16.100";
$username = "admin";
$password = "secret";
$dbname = "simpledb";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}
$query = mysqli_query($conn,"SELECT * FROM lab1")
        or die (mysqli_fetch_error($query));
while ($row = mysqli_fetch_array($query)) {
        echo $row['testdata'];
}
?>

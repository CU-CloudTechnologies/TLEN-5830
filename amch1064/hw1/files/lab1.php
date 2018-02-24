<html>
	<body>
<?php
echo "<h1> Server: ". $_SERVER['SERVER_ADDR'] . "</h1>";
$servername = getenv("DB_HOST");
$username = getenv("DB_USER");
$password = getenv("DB_PASSWORD");
$dbname = "lab1db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
}
$sql = "SELECT id, name, author FROM labs where name='lab 1' limit 1";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
	// output data of each row
	while($row = $result->fetch_assoc()) {
	echo "<h1> Welcome to " . $row["name"]. " created by " . $row["author"]. "</h1>";
	}
} else {
	echo "0 results";
}
$conn->close();
?>
	</body>
</html>

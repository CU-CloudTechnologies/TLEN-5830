<? echo "<p>Hello Cloud Technologies</p>"; 
$servername = "172.16.0.2";
$username_db = "root";
$password_db = "password";
$db = "Animals";
$port = 3306;  
$conn = mysqli_connect($servername, $username_db, $password_db, $db, $port);
printf("Connection successful: %s\n", $conn->host_info);
$sql = "SELECT animal_id,animal_name FROM Animals;";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // print data of each row
    while($row = $result->fetch_assoc()) {
        echo "ID: " . $row["animal_id"]. " - Name: " . $row["animal_name"]. " " . $row["lastname"]. "<br>";
    }
} else {
    echo "0 results";
}
$conn->close();
?>
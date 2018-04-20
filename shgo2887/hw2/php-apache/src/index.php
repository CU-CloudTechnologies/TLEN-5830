<? echo "<p>Hello?</p>"; 
$servername = "172.17.0.2";
$username_db = "root";
$password_db = "my-secret-pw";
$db = "recipes_database";
$port = 3306;  
$conn = mysqli_connect($servername, $username_db, $password_db, $db, $port);
printf("Hurrayyyy  connected: %s\n", $conn->host_info);
$sql = "SELECT recipe_id,recipe_name FROM recipes_database.recipes;";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["recipe_id"]. " - Name: " . $row["recipe_name"]. " " . $row["lastname"]. "<br>";
    }
} else {
    echo "0 results";
}
$conn->close();
?>
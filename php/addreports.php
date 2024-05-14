<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $Userid = $_POST['Userid'];
    $date = $_POST['date'];
    $day = $_POST['day'];
    $Endometrium = $_POST['Endometrium'];
    $Leftovery = $_POST['Leftovery'];
    $Rightovery = $_POST['Rightovery'];

    // Check if the Userid and date combination already exists in addreports
    $check_sql = "SELECT Userid FROM addreport WHERE Userid = '$Userid' AND date = '$date'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User and date combination already exists
        $response = array('status' => false, 'message' => 'Report for this user and date already exists.');
        echo json_encode($response);
    } else {
        // Insert data into the addreports table
        $sql = "INSERT INTO addreport (Userid, date, day, Endometrium, Leftovery, Rightovery) VALUES 
        ('$Userid', '$date', '$day', '$Endometrium', '$Leftovery', '$Rightovery')";

        if ($conn->query($sql) === TRUE) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Patient report added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>

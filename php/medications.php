<?php
require_once('con.php');

// Check if the request is a POST request and if required fields are provided
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['userId'], $_POST['medicineName'], $_POST['time'], $_POST['quantity'], $_POST['label'])) {
    // Get input data from the application
    $userId = $_POST['userId'];
    $medicineName = $_POST['medicineName'];
    $time = $_POST['time'];
    $quantity = $_POST['quantity'];
    $label = $_POST['label'];
    
    // Get the current date and format it as dd-mm-yyyy
    $date = date("Y-m-d");

    // Prepare SQL statement to insert data into the medicationdetails table
    $sql = "INSERT INTO medicationdetails (Userid, MedicineName, Time, quantity, label, date) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Bind parameters and execute the query
        $stmt->bind_param('ssssss', $userId, $medicineName, $time, $quantity, $label, $date);
        if ($stmt->execute()) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Medication was added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
            echo json_encode($response);
        }
        $stmt->close();
    } else {
        // Error preparing the SQL statement
        $response = array('status' => false, 'message' => 'Error preparing the SQL statement.');
        echo json_encode($response);
    }
} else {
    // Required fields not provided in the request
    $response = array('status' => false, 'message' => 'Required fields are missing in the request.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>

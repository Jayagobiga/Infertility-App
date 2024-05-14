<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $contactno = $_POST['contactno'];
    $age = $_POST['age'];
    $height = $_POST['height'];
    $weight = $_POST['weight'];
    $bloodgroup = $_POST['bloodgroup'];
    $medicalhistory = $_POST['medicalhistory'];

    // Check if the user_id already exists in addspouse
    $check_sql = "SELECT Userid FROM addspouse WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User already exists, update the data
        $update_sql = "UPDATE addspouse SET Name = '$name', Contactnumber = '$contactno', 
                       Age = '$age', Height = '$height', Weight = '$weight', 
                       Bloodgroup = '$bloodgroup', Medicalhistory = '$medicalhistory' 
                       WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Spouse details were updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error updating record: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User does not exist, insert data into addspouse table
        $insert_sql = "INSERT INTO addspouse (Userid, Name, Contactnumber, Age, Height, Weight, Bloodgroup, Medicalhistory) VALUES (
           '$userid', '$name', '$contactno', '$age', '$height', '$weight', '$bloodgroup', '$medicalhistory')";

        if ($conn->query($insert_sql) === TRUE) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Spouse details were added successfully.');
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

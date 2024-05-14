<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' and 'date' are set
    if (isset($_POST['userid'])) {
        // Get the Userid and date from the POST data
        $userid = trim($_POST['userid']);
        // SQL query to retrieve entries for a given Userid and date
        $check_sql = "SELECT Userid, Name, ContactNo, Marriageyear, Bloodgroup FROM addpatient WHERE LOWER(TRIM(Userid)) = LOWER(TRIM('$userid'))";
        $result = $conn->query($check_sql);

        if ($result->num_rows > 0) {
            // Fetch all rows as an associative array
            $patientdisplay = array();
            while ($row = $result->fetch_assoc()) {
                $patientdisplay[] = $row;
            }

            // Return entries for the given Userid and date as JSON with proper Content-Type header
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'patientdisplay' => $patientdisplay));
        } else {
            // No data found with the provided Userid and date
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No data found with the provided Userid and date.'));
        }
    } else {
        // 'userid' or 'date' not provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide  userid .'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>

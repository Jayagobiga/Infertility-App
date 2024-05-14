<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' is set
    if (isset($_POST['userid'])) {
        // Get the Userid from the POST data
        $userid = trim($_POST['userid']);

        // SQL query to retrieve doctor information based on dr_userid
        $sql = "SELECT * FROM doctor_profile WHERE LOWER(TRIM(dr_userid)) = LOWER(TRIM('$userid'))";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // Fetch doctor details as an associative array
            $doctorDetails = $result->fetch_assoc();

            // Get the image path from the doctor details
            $imagePath = $doctorDetails['doctorimage'];

            // Check if image path is not empty
            if (!empty($imagePath)) {
                // Read the image file contents
                $imageData = file_get_contents($imagePath);

                if ($imageData !== false) {
                    // Encode the image data as base64
                    $base64Image = base64_encode($imageData);

                    // Add the base64 encoded image data to the doctor details
                    $doctorDetails['doctorimage'] = $base64Image;
                } else {
                    // Failed to read image file
                    $doctorDetails['doctorimage'] = ''; // Set empty string for image data
                }
            } else {
                // No image path provided
                $doctorDetails['doctorimage'] = ''; // Set empty string for image data
            }

            // Return doctor details as JSON with proper Content-Type header
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'doctorDetails' => $doctorDetails));
        } else {
            // No doctor found with the provided dr_userid
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No doctor found with the provided Userid.'));
        }
    } else {
        // 'userid' not provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a userid.'));
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

// Close the database connection
$conn->close();
?>

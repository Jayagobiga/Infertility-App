<?php
require_once('con.php');

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['dr_userid'] ?? '';
    $name = $_POST['dr_name'] ?? '';
    $mobilenumber = $_POST['contact_no'] ?? '';
    $password = $_POST['password'] ?? '';
    $repassword = $_POST['repassword'] ?? '';
    $email = $_POST['email'] ?? '';
    $designation = $_POST['designation'] ?? '';

    // Check if a file was uploaded
    if (isset($_FILES['doctorimage']) && $_FILES['doctorimage']['error'] === UPLOAD_ERR_OK) {
        $imagePath = 'doctor_image/' . time() . '.jpg'; // Generate a unique filename
        $uploadDir = __DIR__ . '/'; // Directory where the images will be stored
        $uploadPath = $uploadDir . $imagePath;

        // Move the uploaded file to the specified directory
        if (move_uploaded_file($_FILES['doctorimage']['tmp_name'], $uploadPath)) {
            // Insert the data into the database
            $sql = "INSERT INTO doctor_profile (dr_userid, dr_name, email, contact_no, password, repassword, doctorimage, designation) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssssssss", $username, $name, $email, $mobilenumber, $password, $repassword, $imagePath, $designation);

            if ($stmt->execute()) {
                // Output a success response
                echo json_encode(['status' => 'success', 'message' => 'User registration successful.']);

                // Display the uploaded image path
                echo '<img src="' . $imagePath . '" />';
            } else {
                // Output an error response
                echo json_encode(['status' => 'error', 'message' => 'Error: ' . $stmt->error]);
                error_log("Database insertion error: " . $stmt->error);
            }

            $stmt->close();
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to move uploaded file.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No file uploaded.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

$conn->close();
error_log("Database connection closed.");
?>
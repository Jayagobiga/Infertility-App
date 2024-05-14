<?php
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate if all fields are provided
    $required_fields = ['userid', 'name', 'contactno', 'age', 'gender', 'height', 'weight', 'address', 'marriageyear', 'bloodgroup', 'medicalhistory'];

    foreach ($required_fields as $field) {
        if (empty($_POST[$field])) {
            $response = array('status' => false, 'message' => 'All fields are required.');
            echo json_encode($response);
            exit; // Stop execution if any field is empty
        }
    }

    // Check if file is uploaded
    if (isset($_FILES['image'])) {
        $file_name = $_FILES['image']['name'];
        $file_tmp = $_FILES['image']['tmp_name'];
        $file_type = $_FILES['image']['type'];
        $file_size = $_FILES['image']['size'];
        $file_ext_arr = explode('.', $_FILES['image']['name']);
        $file_ext = strtolower(end($file_ext_arr));

        $extensions = array("jpeg", "jpg", "png");

        if (in_array($file_ext, $extensions) === false) {
            $response = array('status' => false, 'message' => 'Image extension not allowed, please choose a JPEG or PNG file.');
            echo json_encode($response);
            exit;
        }

        // Generate a unique name for the image
        $image_name = uniqid() . '.' . $file_ext;

        // Move uploaded file to the specified folder
        $upload_path = "patient_image/" . $image_name;
        move_uploaded_file($file_tmp, $upload_path);
    } else {
        // Image not uploaded
        $upload_path = ""; // Set empty path
    }

    // Get input data from the application
    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $contactno = $_POST['contactno'];
    $age = $_POST['age'];
    $gender = $_POST['gender'];
    $height = $_POST['height'];
    $weight = $_POST['weight'];
    $address = $_POST['address'];
    $marriageyear = $_POST['marriageyear'];
    $bloodgroup = $_POST['bloodgroup'];
    $medicalhistory = $_POST['medicalhistory'];

    // Check if the user_id already exists in transporter_signup
    $check_sql = "SELECT Userid FROM addpatient WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // Update data in the transporter_signup table
        $update_sql = "UPDATE addpatient SET Name = '$name', ContactNo = '$contactno', Age = '$age', Gender = '$gender', Height = '$height', Weight = '$weight', Address = '$address', Marriageyear = '$marriageyear', Bloodgroup = '$bloodgroup', Medicalhistory = '$medicalhistory', Image = '$upload_path' WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Patient details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User does not exist
        $response = array('status' => false, 'message' => 'User does not exist.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>

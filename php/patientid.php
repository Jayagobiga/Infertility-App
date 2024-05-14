<?php
require_once('con.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $name = isset($_POST['name']) ? $_POST['name'] : 'name'; // Set default if not provided
    $contactno = isset($_POST['contactno']) ? $_POST['contactno'] : 'contactnumber'; // Set default if not provided
    $age = isset($_POST['age']) ? $_POST['age'] : 'age'; // Set default if not provided
    $gender = isset($_POST['gender']) ? $_POST['gender'] : 'gender'; // Set default if not provided
    $height = isset($_POST['height']) ? $_POST['height'] : 'height'; // Set default if not provided
    $weight = isset($_POST['weight']) ? $_POST['weight'] : 'weight'; // Set default if not provided
    $address = isset($_POST['address']) ? $_POST['address'] : 'address'; // Set default if not provided
    $marriageyear = isset($_POST['marriageyear']) ? $_POST['marriageyear'] : 'yom'; // Set default if not provided
    $bloodgroup = isset($_POST['bloodgroup']) ? $_POST['bloodgroup'] : 'bloodgroup'; // Set default if not provided
    $medicalhistory = isset($_POST['medicalhistory']) ? $_POST['medicalhistory'] : 'medicalhistory'; // Set default if not provided
    $password = isset($_POST['password']) ? $_POST['password'] : 'WELCOME'; // Set default if not provided
    $repassword = isset($_POST['repassword']) ? $_POST['repassword'] : 'WELCOME'; // Set default if not provided

    // Insert data into the addpatient table
    $sql = "INSERT INTO addpatient (Name, ContactNo, Age, Gender, Height, Weight, Address, Marriageyear, Bloodgroup, Medicalhistory, Specifications, password, repassword) 
            VALUES ('$name', '$contactno', '$age', '$gender', '$height', '$weight', '$address', '$marriageyear', '$bloodgroup', '$medicalhistory', 'NO SPECIFICATIONS SPECIFIED', '$password', '$repassword')";

    if ($conn->query($sql) === TRUE) {
        // Successful insertion
        $last_id = $conn->insert_id; // Get the auto-generated Userid
        $response = array('status' => true, 'message' => 'Patient registration successful.', 'Userid' => $last_id);
        echo json_encode($response);
    } else {
        // Error in database insertion
        $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
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

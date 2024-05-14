<?php
require_once('con.php'); // Include your database connection file

// Check if the user ID is provided
if (isset($_GET['userId'])) {
    $userId = $_GET['userId'];

    // Prepare and execute SQL query to fetch image data for the specified user ID
    $sql = "SELECT Image FROM addpatient WHERE Userid = '$userId'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Fetch the image data
        $row = $result->fetch_assoc();
        $imagePath = $row['Image'];

        // Set the appropriate content type header for image
        header("Content-type: image/jpeg"); // Adjust content type based on your image format

        // Output the image data
        echo file_get_contents("http://192.168.151.27:80/infertility/$imagePath");
    } else {
        // If no image found for the user ID, return a placeholder image or appropriate error message
        // For example:
        // header("Content-type: image/jpeg");
        // echo file_get_contents('path_to_placeholder_image.jpg');
        echo "Image not found for the specified user ID.";
    }
} else {
    // If user ID is not provided, return an appropriate error message
    echo "User ID is not provided.";
}

$conn->close(); // Close database connection
?>

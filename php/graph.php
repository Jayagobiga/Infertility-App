<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

$response = array();

if (isset($_GET['userid'])) {
    // Retrieve the 'userid' parameter value
    $userid = $_GET['userid'];

    $sql = "SELECT * 
            FROM addreport 
            WHERE Userid = ? 
            ORDER BY date DESC";  // Add the ORDER BY clause

    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, "s", $userid);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($result->num_rows > 0) {
        $response['status'] = true;
        $response['message'] = "Data found";
        $response['data'] = array();   // Array to store graph data

        while ($row = $result->fetch_assoc()) {
            $dataEntry = array(
                'date' => $row['date'],
                'endometrium' => (float)$row['Endometrium'], // Convert to float
                'leftOvary' => (float)$row['Leftovery'], // Convert to float
                'rightOvary' => (float)$row['Rightovery'] // Convert to float
            );

            array_push($response['data'], $dataEntry);
        }
    } else {
        $response['status'] = false;
        $response['message'] = "No results found";
    }
} else {
    // If 'userid' parameter is not set, handle the error accordingly
    $response['status'] = false;
    $response['message'] = "'userid' parameter not found in the URL.";
}

$conn->close();

// Convert PHP array to JSON and output the response
$jsonResponse = json_encode($response);

if ($jsonResponse === false) {
    // Handle JSON encoding error
    $errorResponse = array(
        'status' => false,
        'message' => 'JSON encoding error: ' . json_last_error_msg()
    );
    echo json_encode($errorResponse);
} else {
    echo $jsonResponse;
}
?>

<?php
require_once('con.php');

function jsonResponse($status, $message) {
    echo json_encode(array('status' => $status, 'message' => $message));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userid = isset($_POST['userId']) ? $_POST['userId'] : '';

    if (empty($userid)) {
        jsonResponse(false, "User ID is required.");
        exit;
    }

    // Check if the user_id already exists
    $check_sql = $conn->prepare("SELECT dr_userid FROM doctor_profile WHERE dr_userid = ?");
    $check_sql->bind_param("s", $userid);
    $check_sql->execute();
    $result = $check_sql->get_result();

    if ($result->num_rows == 0) {
        jsonResponse(false, "User does not exist.");
        exit;
    }

    $fields = [];
    $params = [];
    $types = "";

    if (isset($_POST['name']) && $_POST['name'] !== '') {
        $fields[] = "dr_name=?";
        $params[] = $_POST['name'];
        $types .= "s";
    }

    if (isset($_POST['email']) && $_POST['email'] !== '') {
        $fields[] = "email=?";
        $params[] = $_POST['email'];
        $types .= "s";
    }

    if (isset($_POST['designation']) && $_POST['designation'] !== '') {
        $fields[] = "designation=?";
        $params[] = $_POST['designation'];
        $types .= "s";
    }

    if (isset($_POST['contactno']) && $_POST['contactno'] !== '') {
        $fields[] = "contact_no=?";
        $params[] = $_POST['contactno'];
        $types .= "s";
    }

    if (count($fields) > 0) {
        $update_sql = "UPDATE doctor_profile SET " . join(", ", $fields) . " WHERE dr_userid=?";
        $stmt = $conn->prepare($update_sql);
        $params[] = $userid;
        $types .= "s";
        $stmt->bind_param($types, ...$params);

        if ($stmt->execute()) {
            jsonResponse(true, "User data updated successfully.");
        } else {
            jsonResponse(false, "Error updating record: " . $conn->error);
        }
    } else {
        jsonResponse(false, "No data provided to update.");
    }
} else {
    jsonResponse(false, "Invalid request method.");
}

$conn->close();
?>

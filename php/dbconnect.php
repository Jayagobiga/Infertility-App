<?php
class DbConnect {
    private $con;

    function __construct() {
        $this->con = $this->connect();
    }

    function connect() {
        include_once dirname(_FILE_) . '/con.php';

        $this->con = new mysqli(DB_SERVER, DB_USER, DB_PASS, DB_NAME);
        
        if ($this->con->connect_error) {
            die("Connection failed: " . $this->con->connect_error);
        }

        return $this->con;
    }
}
?>
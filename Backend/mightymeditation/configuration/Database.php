<?php
require_once('Connection.php');

class Database extends Connection
{
    public $connection;
    private $conn;
    
    function __construct()
    {
        $this->conn = Connection::getConnection();

        $this->connection = new mysqli($this->conn['db_server'], $this->conn['db_username'], $this->conn['db_password'], $this->conn['db_name']);
        // Check connection
        if($this->connection->connect_error){
            header("Location: login.php?error=connect_error");
            die;
        }
    }

    function mightyQuery($query)
    {
        // return $this->connection->query($query);
        return mysqli_query($this->connection, $query);
    }

    function mightyNumRows($result)
    {
        return mysqli_num_rows($result);
    }

    function mightyFetchArray($result)
    { 
        return mysqli_fetch_array($result, MYSQLI_ASSOC);
    }
}

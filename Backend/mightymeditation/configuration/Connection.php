<?php

Class Connection{
    public $connection;

    function getConnection()
    {
        $connection['db_server']    = 'localhost';
        $connection['db_username']  = 'root';
        $connection['db_password']  = 'root';
        $connection['db_name']      = 'mightymeditation';        
        
        return $connection;
    }
    
}
<?php
if (is_file('configuration/Database.php'))
{
    require_once('configuration/Database.php');
} else {
    require_once('../configuration/Database.php');
}

Class AppSetting extends Database 
{
    private $table = 'app_settings';

    private $id;
    private $key;
    private $value;

    function setFields($field_array, $files = null)
    {
        $this->key      = $field_array['type'];
        $this->value    = $field_array['value'];
    }

    function mightyGetRecord()
    {
        $query = $this->mightyFetchArray($this->mightyQuery("SELECT * FROM $this->table "));
        return $query;
    }

    function mightySave()
    {      
        $values = json_encode($this->value,JSON_UNESCAPED_UNICODE);
        
        $result = $this->mightyGetByKey($this->key);
        
        if( $result == null )
        {
            $record = "INSERT INTO $this->table VALUES(NULL,'".$this->key."','".$values."')";
            $message = "Setting has been saved successfully";
        } else {
            $record = "UPDATE $this->table SET `value` = '$values' WHERE `key` = '".$this->key."' ";
            $message = "Setting has been updated successfully";
        }
        try {
            $this->mightyQuery($record);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Settings has been failed.";
        }
        
        echo '<script> location.href = "index.php?page='.$this->key.'   "; </script>';
        die;
    }

    function mightyGetByID($id)
    {
        $query = "SELECT * FROM $this->table WHERE `id` = '".$id."'";
        return $this->mightFetchArray($this->query($query));
    }

    function mightyGetByKey($key)
    {
        $this->key = $key;
        $query = $this->mightyQuery("SELECT * FROM $this->table WHERE `key` = '".$this->key."' ");
        return $this->mightyFetchArray($query);
    }
}


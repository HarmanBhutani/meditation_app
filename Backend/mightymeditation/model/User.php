<?php
if (is_file('configuration/Database.php'))
{
    require_once('configuration/Database.php');
} else {
    require_once('../configuration/Database.php');
}

Class User extends Database {
    private $table = 'users';
    private $id;
    private $email;
    private $password;
    private $first_name;
    private $last_name;

    function setFields($field_array)
    {
        $this->id           = isset($field_array['id']) ? $field_array['id'] : '';
        $this->email        = isset($field_array['email']) ? $field_array['email'] : '';
        $this->password     = isset($field_array['password']) ? $field_array['password'] : '';
        $this->cnfm_password= isset($field_array['confirm_password']) ? $field_array['confirm_password'] : '';
        $this->first_name   = isset($field_array['first_name']) ? $field_array['first_name'] : '';
        $this->last_name    = isset($field_array['last_name']) ? $field_array['last_name'] : '';
    }

    public function mightyLogin()
    {
        $query = "SELECT * FROM $this->table WHERE email = '".$this->email."' AND password='".md5($this->password)."'";
        
        $result = $this->mightyQuery($query);
        
        if($this->mightyNumRows($result) > 0) {
            return true;
        } else {
            return false;
        }
    }

    function mightyGetUser()
    {
        $query = "SELECT * FROM $this->table WHERE email = '".$_SESSION['mm_user']."' ";
        return $this->mightyFetchArray($this->mightyQuery($query));

    }

    function mightyUpdateProfile()
    {    
        $result = $this->mightyGetByID($this->id);

        $record = "UPDATE $this->table SET `first_name` = '".$this->first_name."', `last_name` = '".$this->last_name."', `email` = '".$this->email."' WHERE `id` = '".$this->id."' ";
        $message = "Profile has been updated successfully";
       
        try {
            $this->mightyQuery($record);
            $_SESSION['mm_user'] = $this->email;
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=profile_edit"; </script>';
        die;
    }

    function mightyChangePassword()
    {    
        $result = $this->mightyGetByID($this->id);

        if( $this->password != $this->cnfm_password ){
            $_SESSION['error'] = "Password and confirm password not same";
            echo '<script> location.href = "index.php?page=profile"; </script>';
            die;
        }
        
        $record = "UPDATE $this->table SET `password` = '".md5($this->password)."'  WHERE `id` = '".$this->id."' ";
        $message = "Profile has been updated successfully";
       
        try {
            $this->mightyQuery($record);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=profile"; </script>';
        die;
    }

    function mightyGetByID($id)
    {
        $query = "SELECT * FROM $this->table WHERE `id` = '".$id."'";
        return $this->mightyFetchArray($this->mightyQuery($query));
    }
}
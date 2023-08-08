<?php
if (is_file('configuration/Database.php'))
{
    require_once('configuration/Database.php');
} else {
    require_once('../configuration/Database.php');
}

Class Slider extends Database
{
    private $table = 'slider';
    
    private $id;
    private $title;
    private $image;
    private $url;
    private $status;

    function setFields($field_array, $files = null)
    {
        $this->id           = isset($field_array['id']) ? $field_array['id'] : null;
        $this->title        = isset($field_array['title']) ? $field_array['title'] : null;
        $this->url          = isset($field_array['url']) && $field_array['url'] != null ? $field_array['url'] : NULL;
        $this->status       = (isset($field_array['status']) && $field_array['status'] == 'on') ? 1 : 0;
        
        if (isset($files['image']) && file_exists($files['image']['tmp_name'])) {
            $this->image = $files['image'];
        }

    }
        
    function mightyGetRecords($params = null)
    {
        $query = "SELECT * FROM $this->table WHERE status=1 ORDER BY id DESC";
        
        $result = $this->mightyQuery($query);
        
        $records = [];
        
        if($result) {
            while($row = $this->mightyFetchArray($result)) {
                $row['image'] = $row['image'];
                $row['image_url'] = $this->mightyHost().'upload/slider/'.$row['image'];
                $records[] = $row;
            }
        }
        
        return $records;
    }

    function mightySave()
    {
        $image = 'default.png';
        $is_image_upload = false;

        if (isset($this->image) && file_exists($this->image['tmp_name'])) {
            $path = '../upload/slider';
            $image = time().'-'.$this->image['name'];
            move_uploaded_file($this->image['tmp_name'], $path."/".$image);
            $is_image_upload = true;
        }

        if( $this->id == null )
        {
            $record = "INSERT INTO $this->table VALUES(NULL, '".$this->title."', '".$this->url."', '".$image."', '".$this->status."' )";
            $message = "Slider has been saved successfully";
        } else {
            $result = $this->mightyGetByID($this->id);
            if($is_image_upload == false)
            {
                $image = $result['image'];
            }

            $record = "UPDATE $this->table SET `title` = '$this->title', `url` = '$this->url', `image` = '$image' , `status` = '$this->status' WHERE `id` = '".$this->id."' ";
            $message = "Slider has been updated successfully";
        }
        try {
            $this->mightyQuery($record);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=slider"; </script>';
        die;
    }

    function mightyGetByID($id)
    {
        $query = "SELECT * FROM $this->table WHERE `id` = '".$id."'";
        $result = $this->mightyFetchArray($this->mightyQuery($query));
        if($result != null) {
            $result['image_url'] = $this->mightyHost().'upload/slider/'.$result['image'];
        } else {
            $result['image_url'] = null;
        }
        return $result;
    }

    function mightyDelete()
    {
        $result = $this->mightyGetByID($this->id);
        
        $image = $result['image'];

        $query = "DELETE FROM $this->table WHERE `id` = '".$this->id."' ";

        $path = '../upload/slider/'.$image;
        
        if( $image != 'default.png' ) {
            if (file_exists($path)) {
                unlink($path);
            }
        }

        $message = 'Slider has been deleted.';
        try {
            $this->mightyQuery($query);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=slider"; </script>';
        die;
    }
    
    function mightyHost()
    {
        if(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on'){
            $http = "https://";
        } else {
            $http = "http://";   
        }
        
        $host = $http.$_SERVER['HTTP_HOST'];
        
        $host = str_replace('model','', $host.substr(__DIR__, strlen($_SERVER['DOCUMENT_ROOT'])));
        return $host;
    }
}


<?php
if (is_file('configuration/Database.php'))
{
    require_once('configuration/Database.php');
} else {
    require_once('../configuration/Database.php');
}

Class Chapter extends Database
{
    private $table = 'chapter';
    
    private $id;
    private $name;
    private $audio_id;
    private $type;
    private $file;
    private $url;
    private $image;
    private $description;

    function setFields($field_array, $files = null)
    {
        $this->id           = isset($field_array['id']) ? $field_array['id'] : null;
        $this->name         = isset($field_array['name']) ? $field_array['name'] : null;
        $this->audio_id     = isset($field_array['audio_id']) ? $field_array['audio_id'] : null;
        $this->type         = isset($field_array['type']) ? $field_array['type'] : null;
        $this->url          = isset($field_array['url']) && $field_array['url'] != null ? $field_array['url'] : NULL;
        $this->description  = isset($field_array['description']) && $field_array['description'] != null ? trim(strip_tags($field_array['description'])) : NULL;

        if (isset($files['image']) && file_exists($files['image']['tmp_name'])) {
            $this->image = $files['image'];
        }

        if (isset($files['file']) && file_exists($files['file']['tmp_name'])) {
            $this->file = $files['file'];
        }
    }

    function mightyGetRecords($params=null)
    {
        $audio_id = isset($params) & isset($params['audio_id']) ? $params['audio_id'] : null;
        $order = (isset($params['order']) && $params['order'] != '' ) ? $params['order'] : 'ASC';
        $order_by = (isset($params['order_by']) && $params['order_by'] != '' ) ? $params['order_by'] : 'id';
        $search_text = isset($params) & isset($params['search_text']) ? $params['search_text'] : null;
        $count = isset($params) & isset($params['count']) ? $params['count'] : null;

        $limit = (isset($params['limit']) && $params['limit'] != '' ) ? $params['limit'] : 10;
        $page = (isset($params['page']) && $params['page'] != '' ) ? $params['page'] : 1;
        $offset = ( $page - 1 ) * $limit;

        $condition = '';
        $query = "SELECT * FROM $this->table";
        if($audio_id != null) {
            $condition = " WHERE audio_id = {$audio_id} ";
        }

        if( $search_text != null ) {
            $condition = " WHERE name LIKE '%{$search_text}%' ";
        }
        
        if($count){
            $query = $query." ".$condition;
        } else {
            $query = $query." ".$condition." ORDER BY ".$order_by." ". $order." LIMIT $limit OFFSET $offset ";
        }

        $result = $this->mightyQuery($query);
        $records = [];
        if($result != null) {
            while($row = $this->mightyFetchArray($result)) {
                $row['image'] = $this->mightyHost().'upload/chapter/'.$row['image'];
                $row['file'] = $this->mightyHost().'upload/chapter/'.$row['file'];
                $records[] = $row;
            }
        }
        return $records;
    }

    function mightyGetRecord($audio_id)
    {
        $audio_id = isset($audio_id) ? $audio_id : null;
        $records = [];
        
        $condition = '';
        $query = "SELECT * FROM $this->table";
        if($audio_id != null) {
            $condition = " WHERE audio_id = {$audio_id} ";
        }
        $query = $query." ".$condition;

        $result = $this->mightyQuery($query);

        if($result != null){
            while($row = $this->mightyFetchArray($result))
            {
                $row['image'] = $row['image'];
                $row['image_url'] = $this->mightyHost().'upload/chapter/'.$row['image'];
                $row['file'] = $this->mightyHost().'upload/chapter/'.$row['file'];
                
                $records[] = $row;
            }
        }
        return $records;
    }

    function mightySave()
    {
        $image = 'default.png';
        $chapter_file = NULL;
        $is_image_upload = false;
        $is_file_upload = false;
        $description = $this->connection->escape_string($this->description);
        if (isset($this->image) && file_exists($this->image['tmp_name'])) {
            $path = '../upload/chapter';
            $image = time().'-'.$this->image['name'];
            move_uploaded_file($this->image['tmp_name'], $path."/".$image);
            $is_image_upload = true;
        }
        if (isset($this->file) && file_exists($this->file['tmp_name'])) {
            $path = '../upload/chapter';
            $chapter_file = time().'-'.$this->file['name'];
            move_uploaded_file($this->file['tmp_name'], $path."/".$chapter_file);
            $is_file_upload = true;
        }
        if( $this->id == null )
        {
            $record = "INSERT INTO $this->table VALUES(NULL,'".$this->name."', '".$this->audio_id."', '".$this->type."', '".$chapter_file."', '".$this->url."' ,'".$image."','". $description."' )";
            $message = "Chapter has been saved successfully";
        } else {
            
            $result = $this->mightyGetByID($this->id);
            if($is_image_upload == false)
            {
                $image = $result['image'];
            }
            
            if($is_file_upload == false)
            {
                $chapter_file = $result['file'];
            }
            $this->type = isset($this->type) ? $this->type : $result['type'];
            $this->audio_id = isset($this->audio_id) ? $this->audio_id : $result['audio_id'];

            $record = "UPDATE $this->table SET `name` = '$this->name', `type` = '$this->type',  `audio_id` = '$this->audio_id',  `file` = '$chapter_file', `url` = '$this->url', `image` = '$image' , `description` = '$description' WHERE `id` = '".$this->id."' ";
            $message = "Chapter has been updated successfully";
        }
        try {
            $this->mightyQuery($record);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        
        echo '<script> location.href = "index.php?page=audio_edit&id='.$this->audio_id.'"; </script>';
        die;
    }

    function mightyGetByID($id)
    {
        $query = "SELECT * FROM $this->table WHERE `id` = '".$id."'";

        $result = $this->mightyFetchArray($this->mightyQuery($query));
        
        if($result != null) {
            $result['image_url'] = $this->mightyHost().'upload/chapter/'.$result['image'];
            if($result['type'] == 'file') {
                $result['chapter_url'] = $this->mightyHost().'upload/chapter/'.$result['file'];
            } else {
                $result['chapter_url'] = $result['url'];
            }
        } else {
            $result['image_url'] = null;
        }
        return $result;
    }

    function mightyDelete()
    {
        $result = $this->mightyGetByID($this->id);
        
        $image = $result['image'];
        $file = $result['file'];
        $audio_id = $result['audio_id'];
        
        $query = "DELETE FROM $this->table WHERE `id` = '".$this->id."' ";

        $path = '../upload/chapter/'.$image;
        $file_path = '../upload/chapter/'.$file;
        
        if( $image != 'default.png' ) {
            if (file_exists($path)) {
                unlink($path);
            }
        }
        if( $file != null ) {
            if (file_exists($file_path)) {
                unlink($file_path);
            }
        }
        $message = 'Chapter has been deleted.';
        try {
            $this->mightyQuery($query);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=audio_edit&id='.$audio_id.'"; </script>';
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


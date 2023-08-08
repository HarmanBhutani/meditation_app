<?php
if (is_file('configuration/Database.php'))
{
    require_once('configuration/Database.php');
} else {
    require_once('../configuration/Database.php');
}

Class Audio extends Database
{
    private $table = 'audio';
    private $chapter_table = 'chapter';
    
    private $id;
    private $name;
    private $type;
    private $file;
    private $category_id;
    private $image;
    private $url;
    private $is_popular;
    private $created_at;

    function setFields($field_array, $files = null)
    {
        $this->id           = isset($field_array['id']) ? $field_array['id'] : null;
        $this->name         = isset($field_array['name']) ? $field_array['name'] : null;
        $this->type         = isset($field_array['type']) ? $field_array['type'] : null;
        $this->category_id  = isset($field_array['category_id']) ? $field_array['category_id'] : null;
        $this->url          = isset($field_array['url']) && $field_array['url'] != null ? $field_array['url'] : NULL;
        $this->description  = isset($field_array['description']) && $field_array['description'] != null ? trim(strip_tags($field_array['description'])) : NULL;
        $this->is_popular   = (isset($field_array['is_popular']) && $field_array['is_popular'] == 'on') ? 1 : 0;
        $this->created_at   = date('Y-m-d H:i:s');

        if (isset($files['image']) && file_exists($files['image']['tmp_name'])) {
            $this->image = $files['image'];
        }

        if (isset($files['file']) && file_exists($files['file']['tmp_name'])) {
            $this->file = $files['file'];
        }
    }

    function mightyGetRecords($params = null)
    {
        $order = isset($params) & isset($params['order']) ? $params['order'] : 'ASC';
        $order_by = isset($params) & isset($params['order_by']) ? $params['order_by'] : 'id';
        $popular = isset($params) & isset($params['is_popular']) ? $params['is_popular'] : null;
        $category_id = isset($params) & isset($params['category_id']) ? $params['category_id'] : null;
        $search_text = isset($params) & isset($params['search_text']) ? $params['search_text'] : null;
        $count = isset($params) & isset($params['count']) ? $params['count'] : null;
        $category_ids = isset($params) & isset($params['category_ids']) ? $params['category_ids'] : [];
                
        $page = (isset($params['page']) && $params['page'] != '' ) ? $params['page'] : 1;
        $limit = (isset($params['limit']) && $params['limit'] != '' ) ? $params['limit'] : 10;
        $offset = ( $page - 1 ) * $limit;

        $condition = '';
        $query = "SELECT * FROM $this->table";
        if($category_id != null) {
            $condition = " WHERE category_id = {$category_id} ";
        }

        if($category_ids != null && is_array($category_ids)) {
            $category_ids = "'" . implode( "','", $category_ids ) . "'";
            $condition = " WHERE category_id IN ($category_ids) ";
        }

        if($popular != null) {
            $condition = " WHERE is_popular = {$popular} ";
        }
        
        if( $search_text != null ) {
            $condition = " WHERE name LIKE '%{$search_text}%' ";
        }
        if($count){
            $query = $query." ".$condition;
        } else {
            $query = $query." ".$condition." ORDER BY ". $order_by ." ". $order ." LIMIT $limit OFFSET $offset ";
        }
        
        $result = $this->mightyQuery($query);
        $records = [];
        if($result != null){
            while($row = $this->mightyFetchArray($result))
            {
                $category_result = $this->mightyQuery("SELECT `name` FROM `category` WHERE `id` = '".$row['category_id']."' ");

                $category_name = '';
                if($category_result->num_rows > 0)
                {
                    $category_data = $this->mightyFetchArray($category_result);
                    $category_name = $category_data['name'];
                }
                $row['chapter_count'] = 0;
                if($row['type'] == 'chapter'){
                    $chapter_result = $this->mightyQuery("SELECT * FROM $this->chapter_table WHERE `audio_id` = {$row['id']} ");
                    $row['chapter_count'] = $this->mightyNumRows($chapter_result);
                }
                $row['image'] = $this->mightyHost().'upload/audio/'.$row['image'];
                $row['file'] = $this->mightyHost().'upload/audio/'.$row['file'];
                $row['category_name'] = $category_name;
                $records[] = $row;
            }
        }
        return $records;
    }

    function mightyGetRecord()
    {
                
        $result = $this->mightyQuery("SELECT * FROM $this->table ");
        
        $records = [];
        if($result != null){
            while($row = $this->mightyFetchArray($result))
            {
                $category_result = $this->mightyQuery("SELECT `name` FROM `category` WHERE `id` = '".$row['category_id']."' ");

                $category_name = '';
                if($category_result->num_rows > 0)
                {
                    $category_data = $this->mightyFetchArray($category_result);
                    $category_name = $category_data['name'];
                }
                
                $row['image_url'] = $this->mightyHost().'upload/audio/'.$row['image'];
                $row['file'] = $this->mightyHost().'upload/audio/'.$row['file'];
                $row['category_name'] = $category_name;
                $records[] = $row;
            }
        }
        return $records;
    }

    function mightySave()
    {
        $image = 'default.png';
        $audio_file = NULL;
        $is_image_upload = false;
        $is_file_upload = false;
        $description = $this->connection->escape_string($this->description);
        if (isset($this->image) && file_exists($this->image['tmp_name'])) {
            $path = '../upload/audio';
            $image = time().'-'.$this->image['name'];
            move_uploaded_file($this->image['tmp_name'], $path."/".$image);
            $is_image_upload = true;
        }
        if (isset($this->file) && file_exists($this->file['tmp_name'])) {
            $path = '../upload/audio';
            $audio_file = time().'-'.$this->file['name'];
            move_uploaded_file($this->file['tmp_name'], $path."/".$audio_file);
            $is_file_upload = true;
        }
        if( $this->id == null )
        {
            $record = "INSERT INTO $this->table VALUES(NULL,'".$this->name."','".$this->category_id."', '".$this->type."', '".$audio_file."' ,'".$image."','". $description."', '".$this->url."','".$this->is_popular."', '".$this->created_at."' )";
            $message = "Audio has been saved successfully";
        } else {
            
            $result = $this->mightyGetByID($this->id);
            if($is_image_upload == false)
            {
                $image = $result['image'];
            }
            $this->type = isset($this->type) ? $this->type : $result['type'];
            if($is_file_upload == false)
            {
                $audio_file = $result['file'];
            }
            $record = "UPDATE $this->table SET `name` = '$this->name', `type` = '$this->type',  `file` = '$audio_file', `category_id` = '$this->category_id', `url` = '$this->url', `image` = '$image' , `description` = '$description', `is_popular` = '$this->is_popular' WHERE `id` = '".$this->id."' ";
            $message = "Audio has been updated successfully";
        }
        try {
            $this->mightyQuery($record);
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=audio"; </script>';
        die;
    }

    function mightyGetByID($id)
    {
        $query = "SELECT * FROM $this->table WHERE `id` = '".$id."'";

        $result = $this->mightyFetchArray($this->mightyQuery($query));
        
        if($result != null) {
            $result['image_url'] = $this->mightyHost().'upload/audio/'.$result['image'];
            if($result['type'] == 'file') {
                $result['audio_url'] = $this->mightyHost().'upload/audio/'.$result['file'];
            } else {
                $result['audio_url'] = $result['url'];
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
        
        $query = "DELETE FROM $this->table WHERE `id` = '".$this->id."' ";

        $path = '../upload/audio/'.$image;
        $file_path = '../upload/audio/'.$file;
        
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
        $message = 'Audio has been deleted.';
        try {
            $this->mightyQuery($query);
            $chapter_result = $this->mightyQuery("SELECT * FROM $this->chapter_table WHERE `audio_id` = '".$this->id."' ");
        
            $records = [];
            while($row = $this->mightyFetchArray($chapter_result))
            {
                $image = '../upload/chapter/'.$row['image'];
                if( $row['image'] != 'default.png' ) {
                    if (file_exists($image)) {
                        unlink($image);
                    }
                }
                
                $file = '../upload/chapter/'.$row['file'];
                if( $row['file'] != null ) {
                    if (file_exists($file)) {
                        unlink($file);
                    }
                }
            }
            $this->mightyQuery("DELETE FROM $this->chapter_table WHERE `audio_id` = '".$this->id."' ");
            
            $_SESSION['success'] = $message;
        } catch (Exception $e) {
            $_SESSION['error'] = "Failed";
        }
        echo '<script> location.href = "index.php?page=audio"; </script>';
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


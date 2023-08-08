<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Audio.php');
    require_once('../model/Category.php');

    $audio = new Audio();
    
    $id = isset($_GET) && isset($_GET['id']) ? $_GET['id'] : null;
    $row = $audio->mightyGetByID($id);

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['audio_edit'])) {
        unset($_POST['audio_edit']);
        $_POST['id'] = $id;
        $audio->setFields($_POST, $_FILES);
        $audio->mightySave();
    }
    $category = new Category();
    $category_list = $category->mightyGetRecord();
    $type_list = [
        'file' => 'Upload Audio',
        'url' => 'Custom URL',
        'chapter' => 'Chapter'
    ];
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-lg-4">
            <div class="card card-block card-stretch card-height">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title mb-0">Edit Audio</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="">
                        <form method="post" name=""  action="" enctype="multipart/form-data">
                            <input type="hidden" name="audio_edit">
                            <div class="form-group">
                                <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" id="name" value ="<?= isset($row) && isset($row['name'])  ? $row['name'] : '' ?>" placeholder="Enter Name" required>
                            </div>

                            <div class="form-group">
                                <label for="category_id">Category </label>
                                <select class="form-control" name="category_id">
                                    <option value=""> Select Category</option>
                                    <?php
                                        foreach ($category_list as $k => $val) {
                                    ?>
                                        <option value="<?= $val['id'] ?>" <?php if(isset($row) && isset($row['category_id']) && ($val['id'] == $row['category_id'])) echo "selected" ?> > <?= $val['name'] ?></option>
                                    <?php } ?>
                                </select>
                            </div>

                            <div class="form-group" >
                                <label for="type">Type </label>
                                <select class="form-control upload_type" name="type" <?= isset($row) && isset($row['type']) ? 'disabled' : ''  ?> >
                                    <?php
                                        foreach ($type_list as $k => $val) {
                                    ?>
                                        <option value="<?= $k ?>" <?php if(isset($row) && isset($row['type']) && ($k == $row['type'])) echo "selected" ?> > <?= $val ?></option>
                                    <?php } ?>
                                </select>
                            </div>

                            <div class="form-group image_upload">
                                <label for="image" class="form-label">Image</label>
                                <div class="custom-file mb-3">
                                    <input type="file" class="custom-file-input" id="customFile" accept="image/*" name="image">
                                    <label class="custom-file-label" for="customFile">Choose file</label>
                                </div>
                            </div>
                            
                            <?php
                                $image = isset($row) && isset($row['image']) ? $row['image'] : 'default.png';
                                $path = '../upload/audio/';
                            ?>
                            <div class="form-group mt-3 image_upload">
                                <div class="mm-avatar">
                                    <img class="avatar-60 rounded image_preview" src="<?= $path.$image ?>" alt="#" data-original-title="" title="">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" placeholder="Enter Description" rows="3" ><?= isset($row) && isset($row['description'])  ? $row['description'] : '' ?></textarea>
                            </div>
                            <div class="form-group">
                                <label>Is Popular? </label>
                                <div class="custom-control custom-switch">
                                    <input type="checkbox" class="custom-control-input" name="is_popular" id="is_popular" <?= (isset($row) && isset($row['is_popular']) && $row['is_popular'] == 1 ) || ( $id == null ) ? 'checked' : '' ?>>
                                    <label class="custom-control-label" for="is_popular"></label>
                                </div>
                            </div>
                            <hr>
                            <input type="submit" class="btn btn-primary" value="Save">
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card card-block card-stretch card-height">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title mb-0">Chapter List</h4>
                    </div>
                    <a href="?page=chapter_create&audioid=<?= $id ?>" class="btn btn-primary">Add New</a>
                </div>
                <?php
                    require_once './chapter/index.php';
                ?>
            </div>
        </div>
        
    </div>
</div>
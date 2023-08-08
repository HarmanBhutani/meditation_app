<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Chapter.php');
    
    $chapter = new Chapter();
    
    $id = isset($_GET) && isset($_GET['id']) ? $_GET['id'] : null;
    $audio_id = isset($_GET) && isset($_GET['audioid']) ? $_GET['audioid'] : null;
    $row = $chapter->mightyGetByID($id);
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $_POST['id'] = $id;
        $_POST['audio_id'] = $audio_id;
        $chapter->setFields($_POST, $_FILES);
        $chapter->mightySave();
    }
    
    $type_list = [
        'file' => 'Upload Audio',
        'url' => 'Custom URL',
    ];
    
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title"><?= isset($id) ? 'Edit' : 'Add' ?> Chapter</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="">
                        <form method="post"  action="" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<?= $id ?>" />
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" id="name" value ="<?= isset($row) && isset($row['name'])  ? $row['name'] : '' ?>" placeholder="Enter Name" required>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="type">Type </label>
                                    <select class="form-control upload_type" name="type" <?= isset($row) && isset($row['type']) ? 'disabled' : ''  ?> >
                                        <?php
                                            foreach ($type_list as $k => $val) {
                                        ?>
                                            <option value="<?= $k ?>" <?php if(isset($row) && isset($row['type']) && ($k == $row['type'])) echo "selected" ?> > <?= $val ?></option>
                                        <?php } ?>
                                    </select>
                                </div>

                                <div class="form-group col-md-6 file_upload">
                                    <label for="file" class="form-label">Upload Audio</label>
                                    <div class="custom-file mb-3">
                                        <input type="file" class="custom-file-input" id="customFile" accept="audio/*" name="file">
                                        <label class="custom-file-label" for="customFile"><?= isset($row) && isset($row['file']) ? $row['file'] : 'Choose audio file' ?></label>
                                    </div>
                                </div>

                                <div class="form-group col-md-6 file_url">
                                    <label for="url" class="form-label" id="url_label">Custom URL </label>
                                    <input type="url" class="form-control" name="url" id="url" value ="<?= isset($row) && isset($row['url']) ? $row['url'] : '' ?>" placeholder="Enter URL">
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-md-4 image_upload">
                                    <label for="image" class="form-label">Image</label>
                                    <div class="custom-file mb-3">
                                        <input type="file" class="custom-file-input" id="customFile" accept="image/*" name="image">
                                        <label class="custom-file-label" for="customFile">Choose file</label>
                                    </div>
                                </div>
                                
                                <?php
                                    $image = isset($row) && isset($row['image']) ? $row['image'] : 'default.png';
                                    $path = '../upload/chapter/';
                                ?>
                                <div class="form-group col-md-4 mt-3 image_upload">
                                    <div class="mm-avatar">
                                        <img class="avatar-60 rounded image_preview" src="<?= $path.$image ?>" alt="#" data-original-title="" title="">
                                    </div>
                                </div>

                                <div class="form-group col-md-6">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description" placeholder="Enter Description" rows="3" ><?= isset($row) && isset($row['description'])  ? $row['description'] : '' ?></textarea>
                                </div>
                            </div>
                            <hr>
                            <input type="submit" class="btn btn-primary" value="Save">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
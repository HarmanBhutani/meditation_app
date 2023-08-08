<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Slider.php');

    $slider = new Slider();
    
    $id = isset($_GET) && isset($_GET['id']) ? $_GET['id'] : null;
    $row = $slider->mightyGetByID($id);
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $slider->setFields($_POST, $_FILES);
        $slider->mightySave();
    }

?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title"><?= isset($id) ? 'Edit' : 'Add' ?> Slider</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post"  action="" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<?= $id ?>" />
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="title" id="title" value ="<?= isset($row) && isset($row['title'])  ? $row['title'] : '' ?>" placeholder="Enter Title" required>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="image" class="form-label">Image</label>
                                    <div class="custom-file mb-3">
                                        <input type="file" class="custom-file-input" id="customFile" accept="image/*" name="image">
                                        <label class="custom-file-label" for="customFile">Choose file</label>
                                    </div>
                                </div>
                                
                                <?php
                                    $image = isset($row) && isset($row['image']) ? $row['image'] : 'default.png';
                                    $path = '../upload/slider/';
                                ?>
                                <div class="form-group col-md-4 mt-3">
                                    <div class="mm-avatar">
                                        <img class="avatar-60 rounded image_preview" src="<?= $path.$image ?>" alt="#" data-original-title="" title="">
                                    </div>
                                </div>

                                <div class="form-group col-md-6">
                                    <label for="url" class="form-label">URL</label>
                                    <input type="url" class="form-control" name="url" id="url" value ="<?= isset($row) && isset($row['url'])  ? $row['url'] : '' ?>" placeholder="Enter URL">
                                </div>

                                <div class="form-group col-md-3">
                                    <label>Status </label>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" name="status" id="status" <?= (isset($row) && isset($row['status']) && $row['status'] == 1 ) || ( $id == null ) ? 'checked' : '' ?>>
                                        <label class="custom-control-label" for="status"></label>
                                    </div>
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
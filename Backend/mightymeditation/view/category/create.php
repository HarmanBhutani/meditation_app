<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Category.php');

    $category = new Category();
    $id = isset($_GET) && isset($_GET['id']) ? $_GET['id'] : null;
    $row = $category->mightyGetByID($id);
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $category->setFields($_POST, $_FILES);
        $category->mightySave();
    }
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title"><?= isset($id) ? 'Edit' : 'Add' ?> Category</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post"  action="" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<?= $id ?>" />
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" id="name" value ="<?= isset($row) && isset($row['name'])  ? $row['name'] : '' ?>" placeholder="Enter Name" required>
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
                                    $path = '../upload/category/';
                                ?>
                                <div class="form-group col-md-4 mt-3">
                                    <div class="mm-avatar">
                                        <img class="avatar-60 rounded image_preview" src="<?= $path.$image ?>" alt="#" data-original-title="" title="">
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
<?php
require_once('../configuration/Database.php');
require_once('../model/User.php');
$user = new User();
$row = $user->mightyGetUser();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user->setFields($_POST);
    $user->mightyUpdateProfile();
}
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title">Update Profile</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post" action="">
                            <input type="hidden" name="id" value="<?= $row['id'] ?>" >
                            <input type="hidden" name="type" value="profile" >
                            <div class="row">
                                <div class="form-group col-md-6">
                                    <label for="first_name" class="form-label">First Name</label>
                                    <input type="textbox" class="form-control" id="first_name" name="first_name" value ="<?= $row['first_name'] ?>" placeholder="First Name" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_]/g,'')" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="last_name" class="form-label">Last Name</label>
                                    <input type="textbox" class="form-control" id="last_name" name="last_name" value ="<?= $row['last_name'] ?>" placeholder="Last Name" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_]/g,'')" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value ="<?= $row['email'] ?>" placeholder="Email" required>
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
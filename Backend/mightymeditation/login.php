<?php
require("configuration/session.php");

//redirect to template page if the user is logged in
if (logged_in()) {
  header("Location: index.php");
  die;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <title>Mighty Meditation</title>
      
      <!-- Favicon -->
      <link rel="shortcut icon" href="./assets/images/favicon.ico" />
      <link rel="stylesheet" href="./assets/css/backend-plugin.min.css">
      <link rel="stylesheet" href="./assets/css/backend.css?v=1.0.0">
      <link rel="stylesheet" href="./assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
      <link rel="stylesheet" href="./assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
      <link rel="stylesheet" href="./assets/vendor/remixicon/fonts/remixicon.css">
   </head>
  <body class=" ">
    <!-- loader Start -->
    <div id="loading">
        <div id="loading-center"></div>
    </div>
    <!-- loader END -->
    <div class="wrapper">
        <section class="login-content">
            <div class="container h-100">
                <div class="row align-items-center justify-content-center h-100">
                    <div class="col-md-5">
                        <div class="card">
                            <div class="card-body">
                                <div class="auth-logo">
                                <img src="./assets/images/logo.png" class="img-fluid rounded-normal" alt="logo">
                                </div>
                                <h2 class="mb-2 text-center">Sign In</h2>
                                <p class="text-center">To Keep connected with us please login with your personal info.</p>
                                <!-- Validation Errors -->
                                    
                                <?php
                                    if( isset($_GET['error'])){
                                    ?>
                                    <div class="mb-4">
                                        <div class="alert alert-danger" role="alert">
                                            <?php
                                                if( $_GET['error'] == 'connect_error' ){
                                                    echo "Database connection error.";
                                                }

                                                if( $_GET['error'] == 'login' ){
                                                    echo "These credentials do not match our records.";
                                                }
                                            
                                            ?>
                                        </div>
                                    </div>
                                <?php } ?>
                                    
                                <form method="post" action="checklogin.php">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <label>Email</label>
                                                <input class="form-control" name="email" type="email" value="" placeholder="Enter Email">
                                            </div>
                                        </div>
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <label>Password</label>
                                                <input class="form-control" name="password" type="password" value="" placeholder="********">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <button type="submit" class="btn btn-primary">Sign In</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Backend Bundle JavaScript -->
    <script src="./assets/js/backend-bundle.min.js"></script>
    <!-- SweetAlert JavaScript -->
    <script src="./assets/js/sweetalert.js"></script>
    
    <script src="./assets/js/app.js"></script>
</html>
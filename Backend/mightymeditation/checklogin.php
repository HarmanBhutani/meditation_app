<?php
require_once('configuration/Connection.php');
require_once('configuration/session.php');
require_once('model/User.php');

$email = isset($_POST['email']) ? $_POST['email'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';
if (!empty($email) && !empty($password)) {

    $user = new User();
    
    $user->setFields($_POST);
    $user_login = $user->mightyLogin();
    
    if($user_login){
        session_start();
        $_SESSION['mm_user'] = $email;
        header("Location:index.php");
        die;
    } else {
        header("Location: login.php?error=login");
        die;
    } 
} else {
    header("Location: login.php?error=login");
    die;
}
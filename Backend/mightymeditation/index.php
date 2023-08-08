<?php

    session_start();
    if (isset($_SESSION['mm_user'])) {
        header('Location:  ./view/index.php ');
        die;
    } else {
        header('Location:  ./login.php ');
        die;
    }
?>
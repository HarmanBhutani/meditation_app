<?php
    require('../model/Audio.php');
    require('../model/AppSetting.php');
    
    
    $appsetting = new AppSetting();
    $apiconfiguration = $appsetting->mightyGetByKey('apiconfiguration');
    $value = isset($apiconfiguration) ? json_decode($apiconfiguration['value']) : null;

    $audio_order = isset($value) ? $value->audio_order : 'ASC';
    $audio_orderby = isset($value) ? $value->audio_orderby : 'id';
    $limit = isset($value) ? $value->limit : 10;

    $params = [
        'category_ids'  => isset($_POST) && isset($_POST['category_ids']) ? json_decode($_POST['category_ids']) : [],
        'is_popular'    => isset($_POST) && isset($_POST['is_popular']) ? $_POST['is_popular'] : null,
        'category_id'   => isset($_POST) && isset($_POST['category_id']) ? $_POST['category_id'] : null,
        'page'          => isset($_POST) && isset($_POST['page']) ? $_POST['page'] : '1',
        'search_text'   => isset($_POST) && isset($_POST['search_text']) ? $_POST['search_text'] : null,
        'order'         => isset($_POST) && isset($_POST['order']) ? $_POST['order'] : $audio_order,
        'order_by'      => isset($_POST) && isset($_POST['order_by']) ? $_POST['order_by'] : $audio_orderby,
        'limit'         => isset($_POST) && isset($_POST['limit']) ? $_POST['limit'] : $limit
    ];

    $audio = new Audio();
    $audio_records = $audio->mightyGetRecords($params);

    $master_array = $audio_records;

    $newJsonString = json_encode($master_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE );
    http_response_code(200);
    echo $newJsonString;
    die;
    header("Location: ../index.php");
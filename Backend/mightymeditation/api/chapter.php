<?php
    require('../model/Chapter.php');
    require('../model/AppSetting.php');
       
    $appsetting = new AppSetting();
    $apiconfiguration = $appsetting->mightyGetByKey('apiconfiguration');
    $value = isset($apiconfiguration) ? json_decode($apiconfiguration['value']) : null;

    $chapter_order = isset($value) ? $value->chapter_order : 'ASC';
    $chapter_orderby = isset($value) ? $value->chapter_orderby : 'id';
    $limit = isset($value) ? $value->limit : 10;

    $params = [
        'audio_id'      => isset($_GET) && isset($_GET['audio_id']) ? $_GET['audio_id'] : null,
        'search_text'   => isset($_GET) && isset($_GET['search_text']) ? $_GET['search_text'] : null,
        'page'          => isset($_GET) && isset($_GET['page']) ? $_GET['page'] : '1',
        'order'         => isset($_GET) && isset($_GET['order']) ? $_GET['order'] : $chapter_order,
        'order_by'      => isset($_GET) && isset($_GET['order_by']) ? $_GET['order_by'] : $chapter_orderby,
        'limit'         => isset($_GET) && isset($_GET['limit']) ? $_GET['limit'] : $limit
    ];

    $chapter = new Chapter();
    $chapter_records = $chapter->mightyGetRecords($params);

    $master_array = $chapter_records;

    $newJsonString = json_encode($master_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE );
    http_response_code(200);
    echo $newJsonString;
    die;
    header("Location: ../index.php");
<?php
    require('../model/Category.php');
    require_once('../model/AppSetting.php');
    
    $category = new Category();

    $appsetting = new AppSetting();
    $apiconfiguration = $appsetting->mightyGetByKey('apiconfiguration');
    $value = isset($apiconfiguration) ? json_decode($apiconfiguration['value']) : null;

    $category_order = isset($value) ? $value->category_order : 'ASC';
    $category_orderby = isset($value) ? $value->category_orderby : 'id';
    $limit = isset($value) ? $value->limit : 10;

    $params = [
        'page' => isset($_GET) && isset($_GET['page']) ? $_GET['page'] : '1',
        'order' => isset($_GET) && isset($_GET['order']) ? $_GET['order'] : $category_order,
        'order_by' => isset($_GET) && isset($_GET['order_by']) ? $_GET['order_by'] : $category_orderby,
        'limit' => isset($_GET) && isset($_GET['limit']) ? $_GET['limit'] : $limit
    ];
    $category_records = $category->mightyGetRecords($params);
    $master_array = $category_records;

    $newJsonString = json_encode($master_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE );
    http_response_code(200);
    echo $newJsonString;
    die;
    header("Location: ../index.php");
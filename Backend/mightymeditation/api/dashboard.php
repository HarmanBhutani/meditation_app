<?php
    require('../model/AppSetting.php');
    require('../model/Category.php');
    require('../model/Audio.php');
    require('../model/Slider.php');
    
    $master_array = [];

    $appsetting = new AppSetting();
    $appsetting_records = $appsetting->mightyQuery("SELECT * FROM `app_settings`");
    
    if($appsetting_records->num_rows > 0){
        foreach( $appsetting_records as $k => $val ){
            $value = json_decode($val['value']);
            $master_array[$val['key']] = $value;
        }
    }
    
    $apiconfiguration = $appsetting->mightyGetByKey('apiconfiguration');
    $value = isset($apiconfiguration) ? json_decode($apiconfiguration['value']) : null;
    $limit = isset($value) ? $value->limit : 10;

    $category_order = isset($value) ? $value->category_order : 'ASC';
    $category_orderby = isset($value) ? $value->category_orderby : 'id';

    $slider = new Slider();
    $slider_records = $slider->mightyGetRecords([ 'status' => 1 ]);
    $master_array['slider'] = $slider_records;
    
    $audio_order = isset($value) && isset($value->audio_order) ? $value->audio_order : 'ASC';
    $audio_orderby = isset($value) && isset($value->audio_orderby) ? $value->audio_orderby : 'id';

    $audio = new Audio();
    $audio_records = $audio->mightyGetRecords([ 'is_popular' => 1, 'order' => $audio_order, 'order_by' => $audio_orderby ]);

    $master_array['popular_audio'] = $audio_records;

    $master_array['latest_audio'] = $audio->mightyGetRecords([ 'order' => 'DESC', 'order_by' => 'id' ]);
    
    $category = new Category();
    $category_record = $category->mightyGetRecords([ 'order' => $category_order, 'order_by' => $category_orderby ]);
    $category_list = [];
    foreach ($category_record as $key => $value) {
        $value['audio'] = [];
        $value['audio'] = $audio->mightyGetRecords([ 'category_id' => $value['id'], 'order' => $audio_order, 'order_by' => $audio_orderby ]);
        $category_list[] = $value;
    }

    $master_array['category'] = $category_list;

    $newJsonString = json_encode($master_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE );
    http_response_code(200);
    echo $newJsonString;
    
    die;
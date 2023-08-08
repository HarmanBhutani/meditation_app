<?php
require_once('../configuration/Connection.php');
require_once('../model/AppSetting.php');

$app_setting = new AppSetting();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $_POST['type'] = 'apiconfiguration';
        $app_setting->setFields($_POST);
        $app_setting->mightySave();
    }
    $result = $app_setting->mightyGetByKey('apiconfiguration');
    if( $result != null ) {
        $value = json_decode($result['value']);
        $category_order = isset($value->category_order) && $value->category_order != '' ? $value->category_order : 'ASC';
        $category_orderby = isset($value->category_orderby) && $value->category_orderby != '' ? $value->category_orderby : 'id';
        $audio_order = isset($value->audio_order) && $value->audio_order != '' ? $value->audio_order : 'ASC';
        $audio_orderby = isset($value->audio_orderby) && $value->audio_orderby != '' ? $value->audio_orderby : 'id';
        $chapter_order = isset($value->chapter_order) && $value->chapter_order != '' ? $value->chapter_order : 'ASC';
        $chapter_orderby = isset($value->chapter_orderby) && $value->chapter_orderby != '' ? $value->chapter_orderby : 'id';
    } else {
        $value = null;
        $category_order = $chapter_order = $audio_order = 'ASC';
        $category_orderby = $chapter_orderby = $audio_orderby = 'id';
    }

    $order = [
        [ 
            'value' => 'ASC',
            'label' => 'ASC'
        ],
        [ 
            'value' => 'DESC',
            'label' => 'DESC'
        ]
    ];

    $orderby = [
        [ 
            'value' => 'id',
            'label' => 'ID'
        ],
        [ 
            'value' => 'name',
            'label' => 'Name'
        ]
    ];
   
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title">API Configuration</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post" action="">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="limit" class="form-label">Pagination Limit</label>
                                        <input name="value[limit]" id="limit" type="number" class="form-control" value="<?= isset($value) && isset($value->limit)  ? $value->limit : '10' ?>" placeholder="Enter Pagination Limit">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="category_order" class="form-label">Category Order </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($order as $a => $opt) {
                                            $selected = ($category_order == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="category_order_radio_<?= $a ?>" name="value[category_order]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="category_order_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="category_orderby" class="form-label">Category Order By </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($orderby as $a => $opt) {
                                            $selected = ($category_orderby == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="category_orderby_radio_<?= $a ?>" name="value[category_orderby]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="category_orderby_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="audio_order" class="form-label">Audio Order </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($order as $a => $opt) {
                                            $selected = ($audio_order == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="audio_order_radio_<?= $a ?>" name="value[audio_order]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="audio_order_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="audio_orderby" class="form-label">Audio Order By </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($orderby as $a => $opt) {
                                            $selected = ($audio_orderby == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="audio_orderby_radio_<?= $a ?>" name="value[audio_orderby]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="audio_orderby_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="chapter_order" class="form-label">Chapter Order </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($order as $a => $opt) {
                                            $selected = ($chapter_order == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="chapter_order_radio_<?= $a ?>" name="value[chapter_order]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="chapter_order_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="chapter_orderby" class="form-label">Chapter Order By </label>
                                    <div class="form-group">
                                        <?php 
                                        foreach ($orderby as $a => $opt) {
                                            $selected = ($chapter_orderby == $opt['value']) ? "checked" : "";
                                        ?>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="chapter_orderby_radio_<?= $a ?>" name="value[chapter_orderby]"  value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                            <label class="custom-control-label" for="chapter_orderby_radio_<?= $a ?>" > <?= $opt['label'] ?> </label>
                                        </div>
                                        <?php
                                            }
                                        ?>
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
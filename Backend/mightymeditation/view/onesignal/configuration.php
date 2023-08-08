<?php
    require_once('../configuration/Connection.php');
    require_once('../model/AppSetting.php');

    $app_setting = new AppSetting();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $app_setting->setFields($_POST);
        $app_setting->mightySave();
    }
    $result = $app_setting->mightyGetByKey('onesignal_configuration');
    if( $result != null ) {
        $value = json_decode($result['value']);
    } else {
        $value = null;
    }
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title">Onesignal Configuration</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post"  action="">
                            <input type="hidden" name="type" value="onesignal_configuration" />
                            <div class="row">
                                <div class="form-group col-md-6">
                                    <label for="app_id">Onesignal App ID <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="value[app_id]" value ="<?= isset($value) && isset($value->app_id)  ? $value->app_id : '' ?>" placeholder="Onesignal App ID" required="">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="rest_api_key">Onesignal Rest Api <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="value[rest_api_key]" value ="<?= isset($value) && isset($value->rest_api_key)  ? $value->rest_api_key : '' ?>" placeholder="Onesignal Rest Api" required="">
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
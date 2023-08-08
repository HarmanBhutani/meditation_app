<?php
require_once('../configuration/Connection.php');
require_once('../model/AppSetting.php');

$app_setting = new AppSetting();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $_POST['type'] = 'appconfiguration';
        $app_setting->setFields($_POST);
        $app_setting->mightySave();
    }
    $result = $app_setting->mightyGetByKey('appconfiguration');
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
                        <h4 class="card-title">App Configuration</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post" action="" enctype="multipart/form-data">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label for="facebook" class="form-label">Facebook URL </label>
                                        <input name="value[facebook]" id="facebook" type="text" class="form-control" value="<?= isset($value) && isset($value->facebook)  ? $value->facebook : '' ?>" placeholder="Enter Your Facebook URL">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="instagram" class="form-label">Instagram URL </label>
                                        <input name="value[instagram]" id="instagram" type="text" class="form-control" value="<?= isset($value) && isset($value->instagram)  ? $value->instagram : '' ?>" placeholder="Enter Your Instagram URL">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label for="twitter" class="form-label">Twitter URL </label>
                                        <input name="value[twitter]" id="twitter" type="text" class="form-control" value="<?= isset($value) && isset($value->twitter)  ? $value->twitter : '' ?>" placeholder="Enter Your Twitter URL">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="whatsapp" class="form-label">WhatsApp </label>
                                        <input name="value[whatsapp]" id="whatsapp" type="text" class="form-control" value="<?= isset($value) && isset($value->whatsapp)  ? $value->whatsapp : '' ?>" placeholder="Enter Your WhatsApp">
                                    </div>
                                    
                                    <div class="form-group col-md-4">
                                        <label for="privacy_policy" class="form-label">Privacy Policy URL</label>
                                        <input type="url" class="form-control" name="value[privacy_policy]" id="privacy_policy" value ="<?= isset($value) && isset($value->privacy_policy)  ? $value->privacy_policy : '' ?>" placeholder="Enter Privacy Policy URL">
                                    </div>

                                    <div class="form-group col-md-4">
                                        <label for="terms_condition" class="form-label">Terms and Condition</label>
                                        <input type="url" class="form-control" name="value[terms_condition]" id="terms_condition" value ="<?= isset($value) && isset($value->terms_condition)  ? $value->terms_condition : '' ?>" placeholder="Enter Terms and Condition URL">
                                    </div>
                                    
                                    <div class="form-group col-md-4">
                                        <label for="contact_us">Contact Us </label>
                                        <input type="text" class="form-control" name="value[contact_us]" id="contact_us" value ="<?= isset($value) && isset($value->contact_us)  ? $value->contact_us : '' ?>" placeholder="Enter Contact Us">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label for="about_us" class="form-label">About Us</label>
                                        <textarea class="form-control" id="about_us" name="value[about_us]" placeholder="Enter About Us" rows="3" ><?= isset($value) && isset($value->about_us)  ? $value->about_us : '' ?></textarea>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label for="copyright" class="form-label">Copyright</label>
                                        <textarea class="form-control" id="copyright" name="value[copyright]" placeholder="Enter Copyright" rows="3" ><?= isset($value) && isset($value->copyright)  ? $value->copyright : '' ?></textarea>
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
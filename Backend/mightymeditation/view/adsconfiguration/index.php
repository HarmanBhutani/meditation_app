<?php
require_once('../configuration/Connection.php');
require_once('../model/AppSetting.php');

$app_setting = new AppSetting();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $_POST['type'] = 'adsconfiguration';
        $app_setting->setFields($_POST);
        $app_setting->mightySave();
    }
    $result = $app_setting->mightyGetByKey('adsconfiguration');
    if( $result != null ) {
        $value = json_decode($result['value']);
    } else {
        $value = null;
    }

    $ads_option = [
        [ 
            'value' => 'none',
            'label' => 'None'
        ],
        [ 
            'value' => 'admob',
            'label' => 'AdMob'
        ],
        [
            'value' => 'facebook',
            'label' => 'Facebook'
        ],
    ];

    $display_ads = [
        [
            'key' => 'banner_ad_audio_list',
            'label' => 'Banner Ad on All Audio List'
        ],
        [
            'key' => 'banner_ad_category_list',
            'label' => 'Banner Ad on All Category List'
        ],
        [
            'key' => 'banner_ad_audio_detail',
            'label' => 'Banner Ad on All Audio Detail'
        ],
        [
            'key' => 'banner_ad_audio_search',
            'label' => 'Banner Ad on All Audio Search'
        ],
        [
            'key' => 'interstitial_ad_audio_list',
            'label' => 'Interstitial Ad on All Audio List'
        ],
        [
            'key' => 'interstitial_ad_category_list',
            'label' => 'Interstitial Ad on All Category List'
        ],
        [
            'key' => 'interstitial_ad_audio_detail',
            'label' => 'Interstitial Ad on All Audio Detail'
        ]
    ];
   
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title">Ads Configuration</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="new-user-info">
                        <form method="post" action="">
                            <h4 class="mb-3"> Select Ads Type </h4>
                            <hr>
                            <div class="row">
                                <?php 
                                    foreach ($ads_option as $b => $opt) {
                                        $selected = (isset($value->ads_type) && $value->ads_type == $opt['value']) ? "checked" : "";
                                ?>
                                <div class="col-md-3 d-block">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" name="value[ads_type]" id="ads_radio_<?= $b ?>" value="<?= $opt['value'] ?>" <?= $selected ?>  class="custom-control-input">
                                        <label class="custom-control-label" for="ads_radio_<?= $b ?>" ><?= $opt['label'] ?></label>
                                    </div>
                                </div>
                                <?php
                                    }
                                ?>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <h4 class="mb-3">AdMob</h4>
                                    <hr>
                                    <div class="form-group">
                                        <label for="admob_banner_id" class="form-label">Admob Banner Placement ID-Android </label>
                                        <input name="value[admob_banner_id]" id="admob_banner_id" type="text" class="form-control" value="<?= isset($value) && isset($value->admob_banner_id)  ? $value->admob_banner_id : '' ?>" placeholder="Enter Your Admob Banner ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="admob_interstitial_id" class="form-label">Admob Interstitial Placement ID-Android </label>
                                        <input name="value[admob_interstitial_id]" id="admob_interstitial_id" type="text" class="form-control" value="<?= isset($value) && isset($value->admob_interstitial_id)  ? $value->admob_interstitial_id : '' ?>" placeholder="Enter Your Admob Interstitial ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="admob_banner_id_ios" class="form-label">Admob Banner Placement ID-iOS </label>
                                        <input name="value[admob_banner_id_ios]" id="admob_banner_id_ios" type="text" class="form-control" value="<?= isset($value) && isset($value->admob_banner_id_ios)  ? $value->admob_banner_id_ios : '' ?>" placeholder="Enter Your Admob Banner ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="admob_interstitial_id_ios" class="form-label">Admob Interstitial Placement ID-iOS </label>
                                        <input name="value[admob_interstitial_id_ios]" id="admob_interstitial_id_ios" type="text" class="form-control" value="<?= isset($value) && isset($value->admob_interstitial_id_ios)  ? $value->admob_interstitial_id_ios : '' ?>" placeholder="Enter Your Admob Interstitial ID">
                                    </div>
                                    <hr>
                                    <h4 class="mb-3">Facebook</h4>
                                    <hr>
                                    <div class="form-group">
                                        <label for="facebook_banner_id" class="form-label">Facebook Banner Placement ID-Android </label>
                                        <input name="value[facebook_banner_id]" id="facebook_banner_id" type="text" class="form-control" value="<?= isset($value) && isset($value->facebook_banner_id)  ? $value->facebook_banner_id : '' ?>" placeholder="Enter Your Facebook Banner ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="facebook_interstitial_id" class="form-label">Facebook Interstitial Placement ID-Android </label>
                                        <input name="value[facebook_interstitial_id]" id="facebook_interstitial_id" type="text" class="form-control" value="<?= isset($value) && isset($value->facebook_interstitial_id)  ? $value->facebook_interstitial_id : '' ?>" placeholder="Enter Your Facebook Interstitial ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="facebook_banner_id_ios" class="form-label">Facebook Banner Placement ID-iOS </label>
                                        <input name="value[facebook_banner_id_ios]" id="facebook_banner_id_ios" type="text" class="form-control" value="<?= isset($value) && isset($value->facebook_banner_id_ios)  ? $value->facebook_banner_id_ios : '' ?>" placeholder="Enter Your Facebook Banner ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="facebook_interstitial_id_ios" class="form-label">Facebook Interstitial Placement ID-iOS </label>
                                        <input name="value[facebook_interstitial_id_ios]" id="facebook_interstitial_id_ios" type="text" class="form-control" value="<?= isset($value) && isset($value->facebook_interstitial_id_ios)  ? $value->facebook_interstitial_id_ios : '' ?>" placeholder="Enter Your Facebook Interstitial ID">
                                    </div>
                                    <div class="form-group">
                                        <label for="interstitial_ads_interval" class="form-label">Interstitial Ads Interval </label>
                                        <input name="value[interstitial_ads_interval]" id="interstitial_ads_interval" type="number" class="form-control" value="<?= isset($value) && isset($value->interstitial_ads_interval)  ? $value->interstitial_ads_interval : '' ?>" placeholder="Enter Interstitial Ads Interval" min="0">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h4 class="mb-3">Display Ads</h4>
                                    <hr>
                                    <ul class="list-unstyled mb-0">
                                    <?php
                                        foreach ($display_ads as $ads) {
                                            $checked = isset($value) && isset($value->{$ads['key']}) && $value->{$ads['key']} == 1 ? "checked" : "";
                                    ?>
                                        <li class="mb-3">
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="hidden" class="custom-control-input" name="value[<?= $ads['key'] ?>]" value="0">
                                                <input type="checkbox" class="custom-control-input" name="value[<?= $ads['key'] ?>]" id="<?= $ads['key'] ?>" value="1" <?= $checked ?> >
                                                <label class="custom-control-label" for="<?= $ads['key'] ?>"><?= $ads['label'] ?></label>
                                            </div>
                                        </li>
                                    <?php } ?>
                                    </ul>
                                <hr>
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
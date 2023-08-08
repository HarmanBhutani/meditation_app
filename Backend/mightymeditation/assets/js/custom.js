$(document).ready(function() {

    $('#change_password').prop('disabled', true);
    $('#password, #confirm_password').on('keyup', function () {
        if ($('#password').val() == $('#confirm_password').val()) {
            $('#confirm_pass_message').html('');
            $('#change_password').prop('disabled', false);
        } else {
            $('#change_password').prop('disabled', true);
            $('#confirm_pass_message').html('Password and confirm password not same').css('color', 'red');
        }
    });

    if($('.upload_type').length > 0) {
        var upload_type = $('select[name=type]').val();
        changeUploadFile(upload_type);
    
        $(".upload_type").change(function() {
            changeUploadFile(this.value)
        });

        function changeUploadFile(type)
        {
            var label = $(".upload_type option:selected").text();
            
            if (jQuery.inArray(type, ['url']) !== -1) {
                $('.file_url').removeClass('d-none');
                $('.file_upload').addClass('d-none');
                $('#url_label').text(label);
            } else {
                $('.file_upload').removeClass('d-none');
                $('.file_url').addClass('d-none');
            }
            
            if(type == 'chapter')
            {
                $('.file_upload').addClass('d-none');
            }
        }
    }

    $(document).on('change', '.custom-file-input', function() {       
        field_name = $(this).attr('name');
        readURL(this, field_name+'_preview');
    })

    function getExtension(filename) {
        var parts = filename.split('.');
        return parts[parts.length - 1];
    }

    function isImage(filename) {
        var ext = getExtension(filename);
        switch (ext.toLowerCase()) {
            case 'jpg':
            case 'jpeg':
            case 'png':
            case 'gif':
            case 'ico':
                return true;
        }
        return false;
    }

    function isAttachments(filename) {
        var ext = getExtension(filename);
        var validExtensions = [ 'mp3', 'aac', 'wav', '3gp', 'mp4'];

        if (jQuery.inArray(ext.toLowerCase(), validExtensions) !== -1) {
            return true;
        }
        return false;
    }

    function readURL(input,className) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            var field_name = $(input).attr('name');
            var flag = true;
            if (jQuery.inArray(field_name, ['file']) !== -1) {
                res = isAttachments(input.files[0].name);
                
                if(res == false) {
                    var msg = 'This type of files are not allowed';
                    $(input).val("");
                    flag = false;
                }
            } else {
                var res = isImage(input.files[0].name);
                if(res == false){
                    var msg = 'Image should be png/PNG, jpg/JPG & jpeg/JPG.';
                    
                    $(input).val("");
                    flag = false;
                }
                reader.onload = function(e){
                    $(document).find('img.'+className).attr('src', e.target.result);
                    $(document).find("label."+className).text((input.files[0].name));
                }
            }
            if(flag == false)
            {
                Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000
                }).fire({
                    type: 'error',
                    title: msg
                });
                return false;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

});
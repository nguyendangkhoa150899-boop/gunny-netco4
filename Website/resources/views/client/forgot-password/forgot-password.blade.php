@extends('client.master')

@section('content')
<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">QUÊN MẬT KHẨU</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="createAccountForm" class="account">
                <label>Nhập tên tài khoản và captcha, sau đó một Email sẽ gửi đến email của bạn để lấy lại mật khẩu.</label>
                <label>
                    <span>Tên tài khoản</span>
                    <input id="txtUsername" type="text" placeholder="Tên tài khoản cần lấy lại"
                           autocomplete="off" required="">
                </label>
                <label>
                    <span>Xác nhận Captcha</span> <br>
                    <div class="wrapper-captcha">
                        <input type="text" id="txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                               autocomplete="off">
                        <img id="captcha_img_src" src="{{captcha_src()}}"/>
                    </div>
                    <div id="regacc_txtcode_tooltip" class="error-check" style="display:none;">
                    </div>
                </label>
                <label class="errors-register-form" style="display: none;color: red"></label>
                <button class="button" id="forgotPasswordBtn" type="button"> <span class="icon"></span> XÁC NHẬN </button>
            </form>
        </div>
    </div>
</section>
@endsection

@push('js')
    <script type="text/javascript">
        $("#forgotPasswordBtn").click(function (){
            $(".errors-register-form").css('color', 'orange');
            $(".errors-register-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
            $(".errors-register-form").show(),
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-send-email-forgot-pwd')}}",
                    type: "post",
                    dateType: "json",
                    data: {
                        username: $("#txtUsername").val(),
                        captcha: $("#txtCaptcha").val()
                    },
                    success: function(t) {
                        reloadCaptcha();
                        $(".errors-register-form").html(" ");
                        $(".errors-register-form").hide();
                        $('#usernameError').html(" ");
                        $('#usernameError').css("display", "none");
                        $(".errors-register-form").css('color','green');
                        $(".errors-register-form").html("Gửi thư lấy lại mật khẩu thành công. Vui lòng kiểm tra email bạn đã đăng ký (Kiểm tra trong mục spam).");
                        $(".errors-register-form").show();
                        $('#emailError').css("display", "none");
                        $('#createAccountForm').trigger("reset");
                        // $("#create-account-error").html(t), "Đăng ký thành công!" == t && setTimeout(function() {
                        //     window.location = "/"
                        // }, 1e3), setbackgourndCaptcha("captchaImageReg")
                    },
                    error: function (t){
                        reloadCaptcha();
                        if(t.status = 422){
                            let errorMsg = "Gửi thư lấy lại mật khẩu không thành công: </br>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $("#txtCaptcha").val("")
                            $(".errors-register-form").css('color','red');
                            $(".errors-register-form").html(errorMsg);
                            $(".errors-register-form").show();
                        }
                        if(t.status = 400){
                            $("#txtCaptcha").val("")
                            $(".errors-register-form").css('color','red');
                            $(".errors-register-form").html(t.responseJSON.msg);
                            $(".errors-register-form").show();
                        }


                    }
                })
        });
    </script>
@endpush

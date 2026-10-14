@extends('client.master')

@section('content')

    <section class="box register" id="register-section">
        <div class="title-new">
            <h1 style="color: #c3332a">ĐĂNG KÝ TÀI KHOẢN</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist animElement slide-left">
                <form id="createAccountForm" class="account">
                    <label>
                        <span>Tài Khoản</span>
                        <input id="txtUserReg" placeholder="Tên tài khoản"
                               autocomplete="off" required="">
                        <div id="usernameError" class="error-check" style="display:none;">
                            <div id="formtip_inner" class="error-check-mess"></div>
                        </div>
                    </label>

                    <label>
                        <span>Email</span>
                        <input id="txtEmailReg" placeholder="Ex.: abc@gmail.com"
                               autocomplete="off" required="">
                        <div id="emailError" class="error-check" style="display:none;"></div>
                    </label>
                    <label>
                        <span>Số điện thoại</span>
                        <input id="txtPhoneReg" placeholder="Ex.: 0836826812"
                               autocomplete="off" required="">
                        <div id="emailError" class="error-check" style="display:none;"></div>
                    </label>
                    <label>
                        <span>Mật Khẩu</span>
                        <input type="password" id="txtPasswordReg" onchange="checkPassReg();"
                               placeholder="Mật khẩu phải chứa kí tự, chữ in hoa, in thường và số !" autocomplete="off" required="">
                        <div id="regacc_passs_tooltip" class="error-check" style="display:none;"></div>
                    </label>

                    <label>
                        <span>Nhập Lại Mật Khẩu</span>
                        <input type="password" id="txtRePassword-Reg" onchange="checkRePassReg();"
                               placeholder="• • • • • • • • • •" autocomplete="off" required="">
                        <div id="regacc_repasss_tooltip" class="error-check" style="display:none;"></div>
                    </label>

                    <label>
                        <span>Xác nhận Captcha</span> <br>
                        <div class="wrapper-captcha">
                            <input type="text" id="txtCodeReg" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                                   autocomplete="off" required="">
                            <img id="captcha_img_src" src="{{captcha_src()}}"/>
                        </div>
                        <div id="regacc_txtcode_tooltip" class="error-check" style="display:none;">
                        </div>
                    </label>

                    <label class="errors-register-form" style="display: none;color: red"></label>

                    <button class="button" id="register" type="button"> <span class="icon"></span> ĐĂNG KÝ </button>
                </form>
            </div>
        </div>
    </section>



@endsection

@push('js')
    <script type="text/javascript">

        $( document ).ready(function() {

            let time = 0;
            $('#txtUserReg').on('input', function (e) {
                clearTimeout(time);
                time = setTimeout(function() {
                    $('#usernameError').html(" ");
                    $('#usernameError').css("display", "none");
                    let username = $("#txtUserReg").val();

                    if(username.length > 2){
                        $('#usernameError').show();
                        $('#usernameError').css('color','orange');
                        $('#usernameError').html("Đang kiểm tra tên tài khoản...");
                        $.ajax({
                            headers: {
                                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                            },
                            url: '{{route('ajax-check-valid-username')}}',
                            type: 'post',
                            dataType: 'json',
                            data:{
                                Email: username,
                            },
                            success: function (res) {
                                $('#usernameError').show();
                                $('#usernameError').css('color','green');
                                $('#usernameError').html(res.msg);
                            },
                            error: function(e, xhq, stt){
                                let statusCode = e.status;
                                $('#usernameError').show();
                                $('#usernameError').css('color','red');
                                if(statusCode == 400)
                                    $('#usernameError').html(e.responseJSON.msg);
                                if(statusCode == 422)
                                    $('#usernameError').html("Tên tài khoản không hợp lệ");
                            }
                        })
                    }


                }, 500);
            });

            let time2 = 0;
            $('#txtEmailReg').on('input', function (e) {
                clearTimeout(time2);
                time2 = setTimeout(function() {
                    $('#txtEmailReg').html(" ");
                    $('#emailError').css("display", "none");
                    let email = $("#txtEmailReg").val();

                    if(email.length > 4){
                        $('#emailError').show();
                        $('#emailError').css('color','orange');
                        $('#emailError').html("Đang kiểm tra email...");

                        $.ajax({
                            headers: {
                                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                            },
                            url: '{{route('ajax-check-valid-email')}}',
                            type: 'post',
                            dataType: 'json',
                            data:{
                                Fullname: email,
                            },
                            success: function (res) {
                                $('#emailError').show();
                                $('#emailError').css('color','green');
                                $('#emailError').html(res.msg);
                            },
                            error: function(e, xhq, stt){
                                let statusCode = e.status;
                                $('#emailError').show();
                                $('#emailError').css('color','red');
                                if(statusCode == 400)
                                    $('#emailError').html(e.responseJSON.msg);
                                if(statusCode == 422)
                                    $('#emailError').html("Email không hợp lệ");
                            }
                        })
                    }


                }, 500);
            });

            $("#register").click(function (){
                $(".errors-register-form").css('color', 'orange');
                $(".errors-register-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-register-form").show(),
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('auth-ajax-register')}}",
                    type: "post",
                    dateType: "json",
                    data: {
                        Email: $("#txtUserReg").val(),
                        Password: $("#txtPasswordReg").val(),
                        Fullname: $("#txtEmailReg").val(),
                        Phone: $("#txtPhoneReg").val(),
                        captcha: $("#txtCodeReg").val()
                    },
                    success: function(t) {
                        reloadCaptcha();
                        $(".errors-register-form").html(" ");
                        $(".errors-register-form").hide();
                        $('#usernameError').html(" ");
                        $('#usernameError').css("display", "none");
                        $(".errors-register-form").css('color','green');
                        $(".errors-register-form").html("Đăng ký thành công. Hệ thống sẽ tự động đăng nhập sau giây lát.");
                        $(".errors-register-form").show();
                        $('#emailError').css("display", "none");
                        $('#createAccountForm').trigger("reset");
                        setTimeout(function() {
                            window.location = "/"
                        }, 1e3);
                    },
                    error: function (t){
                        reloadCaptcha();
                        let errorMsg = "Đăng ký không thành công: </br>";
                        $.each( t.responseJSON.errors, function( key, value) {
                            errorMsg += ` - ${value} </br>`;
                        });
                        $("#txtCodeReg").val("");
                        $(".errors-register-form").css('color','red');
                        $(".errors-register-form").html(errorMsg);
                        $(".errors-register-form").show();

                    }
                })
            });

            function checkPassReg() {
                $("#txtPassword-Reg").val().length < 6 ? ($("#regacc_passs_tooltip").css("display", "block"), $("#regacc_passs_tooltip").html("Mật khẩu phải từ 6 kí tự trở lên")) : $("#regacc_passs_tooltip").css("display", "none")
            }

            function checkRePassReg() {
                $("#txtRePassword-Reg").val() != $("#txtPassword-Reg").val() ? ($("#regacc_repasss_tooltip").css("display", "block"), $("#regacc_repasss_tooltip").html("Xác nhận mật khẩu không khớp")) : $("#regacc_repasss_tooltip").css("display", "none")
            }
        });
    </script>
@endpush

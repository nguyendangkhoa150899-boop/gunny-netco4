@extends('client.master')

@section('content')

    <section class="box register">
        <div class="title-new">
            <h1 style="color: #c3332a">CẬP NHẬT TÀI KHOẢN WEB CŨ SANG WEB MỚI</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist animElement slide-left">
                <h3>Chỉ cần nhập vào tài khoản ở web cũ ở đây. Sau đó đăng nhập như bình thường (Chỉ làm 1 lần)</h3>
                <form id="createAccountForm" class="account">
                    <label>
                        <span>Tài Khoản web cũ</span>
                        <input id="txtUserReg" placeholder="Tên tài khoản"
                               autocomplete="off" required="">
                        <div id="usernameError" class="error-check" style="display:none;">
                            <div id="formtip_inner" class="error-check-mess"></div>
                        </div>
                    </label>

                    <label>
                        <span>Mật Khẩu tài khoản web cũ</span>
                        <input type="password" id="txtPasswordReg" onchange="checkPassReg();"
                               placeholder="• • • • • • • • • •" autocomplete="off" required="">
                        <div id="regacc_passs_tooltip" class="error-check" style="display:none;"></div>
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

                    <button class="button" id="transfer" type="button"> <span class="icon"></span> CHUYỂN ĐỔI </button>
                </form>
            </div>
        </div>
    </section>



@endsection

@push('js')
    <script type="text/javascript">

        $( document ).ready(function() {

            $("#transfer").click(function (){
                $(".errors-register-form").css('color', 'orange');
                $(".errors-register-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-register-form").show(),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-transfer-account')}}",
                        type: "post",
                        dateType: "json",
                        data: {
                            Email: $("#txtUserReg").val(),
                            Password: $("#txtPasswordReg").val(),
                            captcha: $("#txtCodeReg").val()
                        },
                        success: function(t) {
                            reloadCaptcha();
                            $(".errors-register-form").html(" ");
                            $(".errors-register-form").hide();
                            $('#usernameError').html(" ");
                            $('#usernameError').css("display", "none");
                            $(".errors-register-form").css('color','green');
                            $(".errors-register-form").html("Chuyển đổi tài khoản thành công, vui lòng đăng nhập vào Form bên trái.");
                            $(".errors-register-form").show();
                            $('#emailError').css("display", "none");
                            $('#createAccountForm').trigger("reset");
                        },
                        error: function (t){
                            reloadCaptcha();
                            if(t.status = 422){
                                let errorMsg = "Chuyển đổi tài khoản không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $("#txtCodeReg").val("")
                                $(".errors-register-form").css('color','red');
                                $(".errors-register-form").html(errorMsg);
                                $(".errors-register-form").show();
                            }
                            if(t.status = 400){
                                $("#txtCodeReg").val("")
                                $(".errors-register-form").css('color','red');
                                $(".errors-register-form").html(t.responseJSON.msg);
                                $(".errors-register-form").show();
                            }
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

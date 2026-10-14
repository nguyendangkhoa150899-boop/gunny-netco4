@extends('client.master')

@section('content')
    <section class="box register">
        <div class="title-new">
            <h1 style="color: #c3332a">ĐỔI MẬT KHẨU MỚI THÔNG QUA LẤY LẠI MẬT KHẨU</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist">
                <form id="changePasswordFrm" class="account">
                    <label>
                        <span>Mật khẩu mới</span>
                        <input id="txtNewPassword" type="password" placeholder="••••••"
                               autocomplete="off" required="">
                        <div id="emailError" class="error-check" style="display:none;"></div>
                    </label>

                    <label>
                        <span>Xác nhận mật khẩu mới</span>
                        <input type="password" id="txtConfirmPassword"
                               placeholder="••••••" autocomplete="off" required="">
                        <div id="regacc_passs_tooltip" class="error-check" style="display:none;"></div>
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
                    <label class="errors-change-password-form" style="display: none;color: red"></label>
                    <button class="button" id="changePasswordBtn" type="button"> <span class="icon"></span> XÁC NHẬN</button>
                </form>
            </div>
        </div>
    </section>
@endsection

@push('js')
    <script type="text/javascript">
        $(document).on('click', '#changePasswordBtn', function(){
            let txtNewPassword = $("#txtNewPassword").val();
            let txtConfirmPassword = $("#txtConfirmPassword").val();
            let txtCaptcha = $("#txtCaptcha").val();
            let currentUrl = window.location.href
            let urlObject = new URL(currentUrl);
            let token = urlObject.searchParams.get("token");
            $.ajax({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                url: "{{route('ajax-reset-password-by-forgot')}}",
                type: "POST",
                dateType: "json",
                data: {
                    token: token,
                    password: txtNewPassword,
                    password_confirmation: txtConfirmPassword,
                    captcha: txtCaptcha,
                },
                success: function(t) {
                    let msg = t.msg;
                    $(".errors-change-password-form").css('color','green');
                    $(".errors-change-password-form").html(msg);
                    $(".errors-change-password-form").show();
                    $('#changePasswordFrm').trigger("reset");
                },
                error: function (t){
                    reloadCaptcha();
                    if (t.status == 422){
                        let errorMsg = "Đổi mật khẩu không thành công: </br>";
                        $.each( t.responseJSON.errors, function( key, value) {
                            errorMsg += ` - ${value} </br>`;
                        });
                        $(".errors-change-password-form").css('color','red');
                        $(".errors-change-password-form").html(errorMsg);
                        $(".errors-change-password-form").show();
                    }
                    else if(t.status = 400){
                        $(".errors-change-password-form").css('color','red');
                        $(".errors-change-password-form").html(t.responseJSON.msg);
                        $(".errors-change-password-form").show();
                    }
                    $('#changePasswordFrm').trigger("reset");
                }
            });
        })
    </script>
@endpush

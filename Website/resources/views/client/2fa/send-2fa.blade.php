@extends('client.master')

@section('content')

    <section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Gửi mã xác thực 2FA</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="createAccountForm" class="account">
                <label>Nhấn gửi mã sau đó kiểm tra Email của bạn (Vui lòng kiểm tra cả trong hộp thư spam)</label>
                {{--                <label>- Mã xác thực đã được gửi đến Email của bạn (Vui lòng kiểm tra cả trong hộp thư spam)</label>--}}
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

                <button class="button" id="verifyEmail" type="button"> <span class="icon"></span> XÁC NHẬN </button>
            </form>
        </div>
    </div>
</section>
@endsection

@push('js')
    <script type="text/javascript">
        /*
        * VERIFY EMAIL
        */
        $(document).on('click', '#verifyEmail', function(){
            $(".errors-register-form").css('color', 'orange');
            $(".errors-register-form").html('Đang gửi email xác thực 2FA, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
            $(".errors-register-form").show(),
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-send-verify-email')}}",
                    type: "post",
                    dateType: "json",
                    data: {
                        captcha: $("#txtCaptcha").val()
                    },
                    success: function(t) {
                        reloadCaptcha();
                        $("#txtCaptcha").val("")
                        $(".errors-register-form").css('color','green');
                        $(".errors-register-form").html("Gửi thư xác thực thành công, vui lòng kiểm tra hòm thư (Cả trong spam).");
                        $(".errors-register-form").show();
                        $('#createAccountForm').trigger("reset");

                    },
                    error: function (t){
                        reloadCaptcha();
                        let errorMsg = "Gửi thư xác thực Email không thành công: </br>";
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
    </script>
@endpush

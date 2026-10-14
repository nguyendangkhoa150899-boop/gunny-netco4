@extends('client.master')

@section('content')

    <section class="box register">
        <div class="title-new">
            <h1 style="color: #c3332a">XÁC THỰC 2 LỚP BẢO MẬT</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist animElement slide-left">
                <form method="POST" action="{{route('execute-verify-2fa')}}" class="account">
                    @csrf
                    <label>- Nhập captcha, sau đó nhấn gửi mã để nhận mã xác thực 2FA, sau đó xác nhận tại đây</label>
                    @if($errors->any())
                        <label style="color: red;padding-top: 5px">{{$errors->first()}}</label>
                    @endif
                    <label>
                        <span>Nhập mã xác thực</span>
                        <input placeholder="Mã xác thực" type="number" name="code"
                               autocomplete="off" required="">
                        <div id="usernameError" class="error-check" style="display:none;">
                            <div id="formtip_inner" class="error-check-mess"></div>
                        </div>
                    </label>
                    <label>
                        <span>Xác nhận Captcha</span> <br>
                        <div class="wrapper-captcha">
                            <input type="number" name="captcha" id="txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                                   autocomplete="off">
                            <img id="captcha_img_src" src="{{captcha_src()}}"/>
                        </div>
                    </label>
                    <label class="errors-verify-twofa-form" style="color: red"></label>
                    <button class="button" type="submit"> <span class="icon"></span> XÁC NHẬN </button>
                    <button id="send-two-factor-code" class="button" type="button"> <span class="icon"></span> GỬI MÃ </button>

                </form>
            </div>
        </div>
    </section>

@endsection


@push('js')
    <script type="text/javascript">
        /*
        * SEND 2FA CODE
        */
        $(document).ready(function (){
            $("#send-two-factor-code").click(function(){
                $(".errors-verify-twofa-form").css('color', 'orange');
                $(".errors-verify-twofa-form").html('Đang gửi email xác thực 2FA, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-verify-twofa-form").show(),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-send-2fa')}}",
                        type: "post",
                        dateType: "json",
                        data: {
                            captcha: $("#txtCaptcha").val()
                        },
                        success: function(t) {
                            reloadCaptcha();
                            $("#txtCaptcha").val("")
                            $(".errors-verify-twofa-form").css('color','green');
                            $(".errors-verify-twofa-form").html("Gửi thư xác thực thành công, vui lòng kiểm tra hòm thư (Cả trong spam).");
                            $(".errors-verify-twofa-form").show();
                        },
                        error: function (t){
                            reloadCaptcha();
                            if(t.status = 422){
                                let errorMsg = "Gửi thư lấy mã xác thực 2FA không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $("#txtCaptcha").val("")
                                $(".errors-verify-twofa-form").css('color','red');
                                $(".errors-verify-twofa-form").html(errorMsg);
                                $(".errors-verify-twofa-form").show();
                            }
                            if(t.status = 400){
                                $("#txtCaptcha").val("")
                                $(".errors-verify-twofa-form").css('color','red');
                                $(".errors-verify-twofa-form").html(t.responseJSON.msg);
                                $(".errors-verify-twofa-form").show();
                            }

                        }
                    })
            });
        });
    </script>
@endpush

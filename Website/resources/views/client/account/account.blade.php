

@extends('client.master')

@section('content')

    <div class="ajax-loader" id="ajax-loader"
         style="
           display: none;
            background-color: rgba(255,255,255,0);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 9999 !important;
            width: 100%;
            height:100%;"
    >
        <img src="{{ url('guest/images/ajax-loader.gif') }}" class="img-responsive" />
    </div>
    <section class="box register">
        <div class="title-new">
            <h1 style="color: #c3332a">TÀI KHOẢN CỦA BẠN</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist animElement slide-left">
                <form class="detail-account">
                    <label style="padding-top: 5px">
                        <span style="width: 25%;">Tên tài khoản:</span>
                        <span>{{Auth::guard('member')->user()->Email}}</span>
                    </label>
                    <label>
                        <span style="width: 25%;">Coin:</span>
                        <span>{{Auth::guard('member')->user()->Money}} Coin</span>
                    </label>
                    <label>
                        <span style="width: 25%;">Vip:</span>
                        <span><img style="margin: 0;" src="/assets/img/vip/vip{{Auth::guard('member')->user()->getVipLevel()}}_big.png" /> (Bonus {{Auth::guard('member')->user()->getVipBonus()}}% khi chuyển xu)</span>
                    </label>
                    <label>
                        <span style="width: 25%;">Exp Vip:</span>
                        <span>{{Auth::guard('member')->user()->VIPExp}}</span>
                    </label>
                    <label>
                        <span style="width: 25%;">Email:</span>
                        @if(!Auth::guard('member')->user()->VerifiedEmail)
                            <span>{{Auth::guard('member')->user()->Fullname}} (❌ Chưa xác thực)</span>
                        @else
                            <span>{{Auth::guard('member')->user()->Fullname}} (✔ Đã xác thực)</span>
                        @endif
                    </label>
                    <label>
                        <span style="width: 25%;">Số điện thoại:</span>
                        <span>{{Auth::guard('member')->user()->Phone != null ? Auth::guard('member')->user()->Phone : 'Chưa cập nhật số điện thoại'}}</span>
                    </label>
                    <label>
                        <span style="width: 25%;">Trạng thái 2FA:</span>
                        <span>{{Auth::guard('member')->user()->TwoFactorStatus ? 'Kích hoạt': 'Chưa kích hoạt'}}</span>
                    </label>
                    <div class="title-new">
                        <h2 style="color: #c3332a;font-size: 23.4px;padding-top: 15px">THIẾT LẬP TÀI KHOẢN </h2>
                    </div>
                    <div>
                        @if($errors->any())
                            <h4 style="color: red;text-align: center">{{$errors->first()}}</h4>
                        @endif
                    </div>
                    <div class="button-functional-account">
                        <button type="button" class="item animElement slide-left" id="changePasswordViewCaller"
                                style="background-color: #0dcaf0; border-color: #0dcaf0;">
                            <img src="/assets/svgs/key.svg" style="fill:white;" alt="nap_tien"> Đổi mật khẩu
                        </button>
                        <a class="item animElement slide-left" id="changeEmailCaller"
                           style="background-color: #198754; border-color: #198754;">
                            <img src="/assets/svgs/envelope.svg" style="fill:white;" alt="nap_tien"> Đổi email
                        </a>
                        @if(Auth::guard('member')->user()->VerifiedEmail)
                            @if( !Auth::guard('member')->user()->TwoFactorStatus)
                                <a class="item animElement slide-left" href="{{route('execute-on-2fa')}}"
                                   style="background-color: #0d6efd; border-color: #0d6efd">
                                    <img src="/assets/svgs/user-check.svg" style="fill:white;" alt="nap_tien"> Bật 2FA
                                </a>
                            @else
                                <a class="item animElement slide-left" href="{{route('execute-off-2fa')}}"
                                   style="background-color: #0d6efd; border-color: #0d6efd">
                                    <img src="/assets/svgs/power-off.svg" style="fill:white;" alt="nap_tien"> Tắt 2FA
                                </a>
                            @endif
                        @else
                            <a class="item animElement slide-left" id="verifyEmailCaller"
                               style="background-color: #0d6efd; border-color: #0d6efd">
                                <img src="/assets/svgs/user-check.svg" style="fill:white;" alt="nap_tien"> Xác thực Email
                            </a>
                        @endif
                        <a class="item animElement slide-left" id="changePhoneCaller"
                           style="background-color: #d84949; border-color: #d84949;">
                            <img src="/assets/svgs/envelope.svg" style="fill:white;" alt="nap_tien"> Đổi SĐT
                        </a>
                    </div>
                    <div class="title-new">
                        <h2 style="color: #c3332a;font-size: 23.4px;padding-top: 15px">CHỨC NĂNG KHÁC</h2>
                    </div>
                    <div>
                        @if($errors->any())
                            <h4 style="color: red;text-align: center">{{$errors->first()}}</h4>
                        @endif
                    </div>
                    <div class="button-functional-account">
                        <a class="item animElement slide-left" id="rechargeCaller"
                           style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">
                            <img src="/assets/svgs/sync-alt.svg" style="fill:white;" alt="nap_tien"> Nạp Tiền
                        </a>
                        <a class="item animElement slide-left" id="convertCoinCaller"
                           style="background-color: #6c757d; border-color: #6c757d;">
                            <img src="/assets/svgs/exchange-alt.svg" style="fill:white;" alt="nap_tien"> Chuyển xu
                        </a>
                        <a class="item animElement slide-left" id="historyRechargeCaller"
                           style="background-color: #343a40; border-color: #343a40;">
                            <img src="/assets/svgs/file-invoice-dollar.svg" style="fill:white;" alt="nap_tien"> Lịch sử nạp thẻ
                        </a>
                        <a class="item animElement slide-left" id="playWithoutAuthenticateCaller"
                           style="background-color: #3d6c9a; border-color: #3d6c9a;">
                            <img src="/assets/svgs/rocket.svg" style="fill:white;" alt="nap_tien"> Link chơi game
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </section>
    <div id="dynamicContentView" style="float: left">

    </div>
@endsection

@push('js')
    <script type="text/javascript">
        $(document).ready(function (){
            let currentURL = window.location.href;
            let urlObject = new URL(currentURL);
            let typeDirect = urlObject.searchParams.get("type");
            if(typeDirect == 'recharge'){
                $(function() {
                    $('#rechargeCaller').click();
                    $([document.documentElement, document.body]).animate({
                        scrollTop: $("#dynamicContentView").offset().top
                    }, 2000);
                });
            }
            if(typeDirect == 'convertCoin'){
                $(function() {
                    $('#convertCoinCaller').click();
                    $([document.documentElement, document.body]).animate({
                        scrollTop: $("#dynamicContentView").offset().top
                    }, 2000);
                });
            }
            if(typeDirect == 'checkin'){
                $(function() {
                    $('#checkinCaller').click();
                    $([document.documentElement, document.body]).animate({
                        scrollTop: $("#dynamicContentView").offset().top
                    }, 2000);
                });
            }
            window.history.replaceState({}, document.title, "{{route('view-account')}}");
        });
    </script>

    <script type="text/javascript">
        $(document).ready(function(){
            /**
             *
             * CALLER VIEW RENDER AREA
             *
             */

            //Recharge
            $("#rechargeCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-recharge')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){
                    }
                });
            });

            //Change password
            $("#changePasswordViewCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-change-password')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){
                    }
                });
            });

            //Verify Email
            $("#verifyEmailCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-verify-email')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){
                    }
                });
            });

            //Convert Coin
            $("#convertCoinCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-convert-coin')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){
                    }
                });
            });
            //Convert Coin helpers
            $(document).on('change', '#txtServer', function(){
                $("#txtPlayerNickName").val("");
                var serverId = $("#txtServer").val();
                if (serverId != null && serverId != 0) {
                    $("#txtPlayerNickName").val("Đang tìm kiếm tên nhân vật");
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-get-player-nickname')}}",
                        type: "POST",
                        dateType: "json",
                        data: {
                            serverId: serverId,
                        },
                        success: function(t) {
                            if (typeof t.nickname != 'undefined') {
                                $("#txtPlayerNickName").val(t.nickname);
                                $("#txtPlayerNickName").removeClass('d-none');
                                $("#selectPlayerNickName").addClass('d-none');
                            } else if (typeof t.msg != 'undefined') {
                                $("#txtPlayerNickName").val(t.msg);
                                $("#txtPlayerNickName").removeClass('d-none');
                                $("#selectPlayerNickName").addClass('d-none');
                            } else {
                                $("#txtPlayerNickName").addClass('d-none');
                                var options = '';
                                t.forEach(function (p) {
                                    options += '<option value="' + p.id + '">'+p.nickname+'</option>';
                                });
                                $("#selectPlayerNickName").html(options);
                                $("#selectPlayerNickName").removeClass('d-none');
                            }
                        },
                        error: function (t){
                            $("#txtPlayerNickName").val(t.responseJSON.msg)
                        }
                    });
                }
            });

            $(document).on('input', '#txtCoinConvert', function(){
                let count = parseInt($("#txtCoinConvert").val());
                if(count >= 1000){
                    let coin = count * heSoCoin;
                    coin += coin * xuBonus / 100;
                    $("#txtMoneyReceive").val(coin);
                }
            });

            //History coin
            $("#historyRechargeCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-history-recharge')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            //Change Email
            $("#changeEmailCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-change-email')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            //Chang Email Helpers
            var timeChangeNewEmail = 0;
            $(document).on('input', '#txtNewEmail', function(){
                clearTimeout(timeChangeNewEmail);
                $('#newEmailError').css('color','orange');
                $("#newEmailError").html("Đang kiểm tra địa chỉ Email...");
                $("#newEmailError").show();
                timeChangeNewEmail = setTimeout(function() {
                    console.log('changed')
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-check-valid-email')}}",
                        type: "POST",
                        dateType: "json",
                        data: {
                            Fullname: $("#txtNewEmail").val(),
                        },
                        success: function(t) {
                            console.log(t)
                            $("#newEmailError").show();
                            $('#newEmailError').css('color','green');
                            $("#newEmailError").html(t.msg)
                        },
                        error: function (t){
                            let errorMsg = "";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $("#newEmailError").css('color','red');
                            $("#newEmailError").html(errorMsg);
                            $("#newEmailError").show();
                        }
                    });
                }, 500);

            });
            //History coin
            $("#changePhoneCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-change-phone')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            $("#playWithoutAuthenticateCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-get-link-play')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            //Change nickname
            $("#changeNickNameCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-change-nickname')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            //checkin
            $("#checkinCaller").click(function (){
                $("#dynamicContentView").html(`<section class="box register"><div class="title-new"><h1 style="color: #c3332a">ĐANG TẢI TRANG...</h1></div></section>`);
                $.ajax({
                    url: "{{route('ajax-view-checkin')}}",
                    type: "get",
                    dateType: "json",
                    success: function(t) {
                        let html = t;
                        $("#dynamicContentView").html(html);
                    },
                    error: function (t){

                    }
                });
            });

            $(document).on('change', '#checkin_txtServer', function(){
                $("#checkin_txtPlayerNickName").val("");
                var serverId = $("#checkin_txtServer").val();
                if (serverId != null && serverId != 0) {
                    $("#checkin_txtPlayerNickName").val("Đang tìm kiếm tên nhân vật");
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-get-player-nickname')}}",
                        type: "POST",
                        dateType: "json",
                        data: {
                            serverId: serverId,
                        },
                        success: function(t) {
                            if (typeof t.nickname != 'undefined') {
                                $("#checkin_txtPlayerNickName").val(t.nickname);
                                $("#checkin_txtPlayerNickName").removeClass('d-none');
                                $("#checkin_selectPlayerNickName").addClass('d-none');
                            } else if (typeof t.msg != 'undefined') {
                                $("#checkin_txtPlayerNickName").val(t.msg);
                                $("#checkin_txtPlayerNickName").removeClass('d-none');
                                $("#checkin_selectPlayerNickName").addClass('d-none');
                            } else {
                                $("#checkin_txtPlayerNickName").addClass('d-none');
                                var options = '';
                                t.forEach(function (p) {
                                    options += '<option value="' + p.id + '">'+p.nickname+'</option>';
                                });
                                $("#checkin_selectPlayerNickName").html(options);
                                $("#checkin_selectPlayerNickName").removeClass('d-none');
                            }
                        },
                        error: function (t){
                            $("#checkin_txtPlayerNickName").val(t.responseJSON.msg)
                        }
                    });
                }
            });

            /**
             *
             * FUNCTIONAL AREA
             *
             */

            /*
             * CHANGE PASSWORD
             */
            $(document).on('click', '#changePasswordBtn', function(){
                let txtOldPassword = $("#txtOldPassword").val();
                let txtNewPassword = $("#txtNewPassword").val();
                let txtConfirmPassword = $("#txtConfirmPassword").val();
                let txtCaptcha = $("#txtCaptcha").val();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-change-password')}}",
                    type: "POST",
                    dateType: "json",
                    data: {
                        oldPassword: txtOldPassword,
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
            });
            /*
            * VERIFY EMAIL
            */

            $(document).on('click', '#verifyEmail', function(){
                $(".errors-register-form").css('color', 'orange');
                $(".errors-register-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
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
                            $(".errors-register-form").html("Gửi thư thành công, vui lòng kiểm tra hòm thư (Cả trong spam).");
                            $(".errors-register-form").show();
                            $('#createAccountForm').trigger("reset");

                        },
                        error: function (t){
                            reloadCaptcha();
                            if(t.status = 422){
                                let errorMsg = "Gửi thư xác thực Email không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $("#txtCodeReg").val("");
                                $(".errors-register-form").css('color','red');
                                $(".errors-register-form").html(errorMsg);
                                $(".errors-register-form").show();
                            }
                            if(t.status = 400){
                                $("#txtCodeReg").val("");
                                $(".errors-register-form").css('color','red');
                                $(".errors-register-form").html(t.responseJSON.msg);
                                $(".errors-register-form").show();
                            }

                        }
                    })
            });

            /*
            * RECHARGE CARD
            */
            $(document).on('click', '#rechargeCardBtn', function(){
                let txtSerial = $("#txtSerial").val();
                let txtPasscard = $("#txtPasscard").val();
                let txtCaptcha = $("#txtCaptcha").val();
                let amountCard = $('#menhgia_the').find(":selected").val();

                let isPassed = true;

                if(txtSerial.length <= 0){
                    console.log("serial Er")
                    $(".serialError").show();
                    isPassed = false;
                }
                else $(".serialError").hide();
                if(txtPasscard.length <= 0){
                    console.log("Passcard Er");
                    $(".passcardError").show();
                    isPassed = false;
                }
                else $(".passcardError").hide();
                if(amountCard.length <= 0){
                    console.log("amountCard Er");
                    $(".amountError").show();
                    isPassed = false
                }
                else $(".amountError").hide();
                if(typeCard == 0){
                    console.log("typeCard Er");
                    $(".typeCardError").show();
                    isPassed = false
                }
                else $(".typeCardError").hide();
                //
                if(!isPassed){
                    return;
                }

                //ConvertTypeCard to Text


                //Turn off error badge
                $(".serialError").hide();
                $(".passcardError").hide();
                $(".amountError").hide();
                $(".typeCardError").hide();

                $(".errors-recharge-form").css('color', 'orange');
                $(".errors-recharge-form").html('Đang xử lý nạp thẻ, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-recharge-form").show();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-recharge-card')}}",
                    type: "POST",
                    dateType: "json",
                    data: {
                        serial: txtSerial,
                        pin: txtPasscard,
                        card_type: typeCard,
                        card_amount: amountCard,
                        captcha: txtCaptcha,
                    },
                    success: function(t) {
                        reloadCaptcha();
                        let msg = t.msg;
                        $(".errors-recharge-form").css('color','green');
                        $(".errors-recharge-form").html(msg);
                        $(".errors-recharge-form").show();
                        $('#changePasswordFrm').trigger("reset");
                    },
                    error: function (t){
                        reloadCaptcha();
                        if (t.status == 422){
                            let errorMsg = "Nạp thẻ không thành công: </br>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $(".errors-recharge-form").css('color','red');
                            $(".errors-recharge-form").html(errorMsg);
                            $(".errors-recharge-form").show();
                        }
                        else if(t.status = 400){
                            $(".errors-recharge-form").css('color','red');
                            $(".errors-recharge-form").html(t.responseJSON.msg);
                            $(".errors-recharge-form").show();
                        }
                        $('#rechargeForm').trigger("reset");
                    }
                });
            })

            /**
             * Convert Coin
             */
            $(document).on('click', '#convertCoinBtn', function(){
                $('.ajax-loader').css("display", "block");

                setTimeout(function () {
                    let coinConvert = parseInt($("#txtCoinConvert").val());
                    let serverId = parseInt($('#txtServer :selected').val());
                    let txtCaptcha = $("#txtCaptcha").val();
                    let isPassed = true;
                    let playerId = 0;
                    if (!$("#selectPlayerNickName").hasClass('d-none')) {
                        playerId = $("#selectPlayerNickName").val();
                    }

                    $(".errors-convert-coin-form").html("");
                    if(serverId == 0 || serverId == null){
                        $(".errors-convert-coin-form").html("Vui lòng chọn server");
                        $(".errors-convert-coin-form").show();
                        isPassed = false;
                    }
                    if(isNaN(coinConvert) ||coinConvert < 1000){
                        $(".errors-convert-coin-form").html("Coin chuyển đổi phải trên 1000");
                        $(".errors-convert-coin-form").show();
                        isPassed = false;
                    }
                    if(!isPassed){
                        return;
                    }

                    //Turn off error badge
                    $(".errors-convert-coin-form").html("");
                    $(".errors-convert-coin-form").hide();

                    $(".errors-convert-coin-form").css('color', 'orange');
                    $(".errors-convert-coin-form").html('Đang xử lý chuyển xu, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                    $(".errors-convert-coin-form").show();
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-convert-coin')}}",
                        type: "POST",
                        dateType: "json",
                        data: {
                            server_id: serverId,
                            coin: coinConvert,
                            captcha: txtCaptcha,
                            playerId: playerId
                        },
                        success: function(t) {
                            let msg = t.msg;
                            $(".errors-convert-coin-form").css('color','green');
                            $(".errors-convert-coin-form").html(msg);
                            $(".errors-convert-coin-form").show();
                            $('#convertCoinFrm').trigger("reset");
                            reloadCaptcha();
                            $('.ajax-loader').css("display", "none");
                        },
                        error: function (t){
                            $('.ajax-loader').css("display", "none");
                            reloadCaptcha();
                            if (t.status == 422){
                                let errorMsg = "Nạp thẻ không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $(".errors-convert-coin-form").css('color','red');
                                $(".errors-convert-coin-form").html(errorMsg);
                                $(".errors-convert-coin-form").show();
                            }
                            else if(t.status = 400){
                                $(".errors-convert-coin-form").css('color','red');
                                $(".errors-convert-coin-form").html(t.responseJSON.msg);
                                $(".errors-convert-coin-form").show();
                            }
                            $('#convertCoinFrm').trigger("reset");
                        }
                    });
                }, 1000);
            });

            /*
            * CHANGE EMAIL ACTION
            */
            $(document).on('click', '#changeEmailBtn', function(){
                $(".errors-change-email-form").css('color', 'orange');
                $(".errors-change-email-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-change-email-form").show(),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-change-email')}}",
                        type: "post",
                        dateType: "json",
                        data: {
                            Fullname: $("#txtNewEmail").val(),
                            code: $("#txtCodeOldMail").val(),
                            captcha: $("#txtCaptcha").val()
                        },
                        success: function(t) {
                            reloadCaptcha();
                            $("#txtCaptcha").val("")
                            $(".errors-change-email-form").css('color','green');
                            $(".errors-change-email-form").html("Thay đổi email thành công!");
                            $(".errors-change-email-form").show();
                            $('#changeEmailFrm').trigger("reset");
                            setTimeout(function() {
                                window.location = "/account"
                            }, 1e3)
                        },
                        error: function (t){
                            reloadCaptcha();
                            if (t.status == 422){
                                $("#txtCaptcha").val("");
                                let errorMsg = "Thay đổi Email không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $(".errors-change-email-form").css('color','red');
                                $(".errors-change-email-form").html(errorMsg);
                                $(".errors-change-email-form").show();
                            }
                            else if(t.status = 400){
                                $("#txtCaptcha").val("");
                                $(".errors-change-email-form").css('color','red');
                                $(".errors-change-email-form").html(t.responseJSON.msg);
                                $(".errors-change-email-form").show();
                            }


                        }
                    })
            });
            /*
            * Send code to change verified email
            */
            $(document).on('click', '#sendChangeEmailCode', function(){
                $(".errors-change-email-form").css('color', 'orange');
                $(".errors-change-email-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-change-email-form").show(),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-send-code-verified-email')}}",
                        type: "post",
                        dateType: "json",
                        data: {
                            captcha: $("#txtCaptcha").val()
                        },
                        success: function(t) {
                            reloadCaptcha();
                            $("#txtCaptcha").val("")
                            $(".errors-change-email-form").css('color','green');
                            $(".errors-change-email-form").html("Gửi mã xác thực để thay đổi email thành công!");
                            $(".errors-change-email-form").show();
                            $('#changeVerifiedEmailFrm').trigger("reset");

                        },
                        error: function (t){
                            if (t.status == 422){
                                $("#txtCaptcha").val("");
                                let errorMsg = "Gửi mã xác thực đến Email không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $(".errors-change-email-form").css('color','red');
                                $(".errors-change-email-form").html(errorMsg);
                                $(".errors-change-email-form").show();
                            }
                            else if(t.status = 400){
                                $("#txtCaptcha").val("");
                                $(".errors-change-email-form").css('color','red');
                                $(".errors-change-email-form").html(t.responseJSON.msg);
                                $(".errors-change-email-form").show();
                            }

                        }
                    })
            });
            /*
             * Change Phone number
             */

            $(document).on('click', '#changePhoneNumber', function(){
                $(".errorMessageAccount").css('color', 'orange');
                $(".errorMessageAccount").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errorMessageAccount").show(),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('ajax-change-phone')}}",
                        type: "post",
                        dateType: "json",
                        data: {
                            Phone: $("#txtNewPhoneNumber").val(),
                            captcha: $("#txtCaptcha").val()
                        },
                        success: function(t) {
                            reloadCaptcha();
                            $("#txtCaptcha").val("")
                            $(".errorMessageAccount").css('color','green');
                            $(".errorMessageAccount").html("Thay đổi số điện thoại thành công.");
                            $(".errorMessageAccount").show();
                            $('#createAccountForm').trigger("reset");
                            setTimeout(function() {
                                window.location = "/account"
                            }, 1e3)

                        },
                        error: function (t){
                            reloadCaptcha();
                            if(t.status = 422){
                                let errorMsg = "Thay đổi số điện thoại không thành công: </br>";
                                $.each( t.responseJSON.errors, function( key, value) {
                                    errorMsg += ` - ${value} </br>`;
                                });
                                $("#txtCodeReg").val("");
                                $(".errorMessageAccount").css('color','red');
                                $(".errorMessageAccount").html(errorMsg);
                                $(".errorMessageAccount").show();
                            }
                            if(t.status = 400){
                                $("#txtCodeReg").val("");
                                $(".errorMessageAccount").css('color','red');
                                $(".errorMessageAccount").html(t.responseJSON.msg);
                                $(".errorMessageAccount").show();
                            }

                        }
                    })
            });

            /*
             * Change Link Play
             */

            $(document).on('click', '#changeLinkPlay', function(){
                //Turn off error badge
                $(".errorMessageAccount").html("");
                $(".errorMessageAccount").hide();

                $(".errorMessageAccount").css('color', 'orange');
                $(".errorMessageAccount").html('Đang xử lý đổi link, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errorMessageAccount").show();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-change-link-play')}}",
                    type: "POST",
                    dateType: "json",
                    data: {
                        captcha: $("#txtCaptcha").val(),
                    },
                    success: function(t) {
                        reloadCaptcha();
                        $(".errorMessageAccount").css('color','green');
                        $(".errorMessageAccount").html("Đổi link chơi game thành công");
                        $(".errorMessageAccount").show();
                        $("#linkPlayGame").val(t.linkPlay);
                        $('#txtCaptcha').val("");
                    },
                    error: function (t){
                        reloadCaptcha();
                        if (t.status == 422){
                            let errorMsg = "Đổi link chơi game không thành công: </br>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $(".errorMessageAccount").css('color','red');
                            $(".errorMessageAccount").html(errorMsg);
                            $(".errorMessageAccount").show();
                        }
                        else if(t.status = 400){
                            $(".errorMessageAccount").css('color','red');
                            $(".errorMessageAccount").html(t.responseJSON.msg);
                            $(".errorMessageAccount").show();
                        }
                        $('#changeLinkPlayFrm').trigger("reset");
                    }
                });
            });

            /*
             * Change Nickname
             */
            $(document).on('click', '#changeNickName', function(){
                //Turn off error badge
                $(".errors-change-nickname-form").css('color', 'orange');
                $(".errors-change-nickname-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-change-nickname-form").show();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-change-nickname')}}",
                    type: "POST",
                    dateType: "json",
                    data: {
                        server_id: $( "select[name=txtServer]").val(),
                        new_name: $("#new_nickname").val(),
                        captcha: $("#txtCaptcha").val(),
                    },
                    success: function(t) {
                        reloadCaptcha();
                        $(".errors-change-nickname-form").css('color','green');
                        $(".errors-change-nickname-form").html("Đổi tên nhân vật thành công");
                        $(".errors-change-nickname-form").show();
                        $('#changeNickNameFrm').trigger("reset");
                    },
                    error: function (t){
                        reloadCaptcha();
                        if (t.status == 422){
                            let errorMsg = "Đổi tên nhân vật không thành công: </br>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $(".errors-change-nickname-form").css('color','red');
                            $(".errors-change-nickname-form").html(errorMsg);
                            $(".errors-change-nickname-form").show();
                        }
                        else if(t.status = 400){
                            $(".errors-change-nickname-form").css('color','red');
                            $(".errors-change-nickname-form").html(t.responseJSON.msg);
                            $(".errors-change-nickname-form").show();
                        }
                        $('#changeNickNameFrm').trigger("reset");
                    }
                });
            });

            $(document).on('click', '#checkinBtn', function(){
                let serverId = parseInt($('#checkin_txtServer :selected').val());
                let txtCaptcha = $("#checkin_txtCaptcha").val();
                let isPassed = true;
                let playerId = 0;
                if (!$("#checkin_selectPlayerNickName").hasClass('d-none')) {
                    playerId = $("#checkin_selectPlayerNickName").val();
                }

                $(".errors-checkin-form").html("");
                if(serverId == 0 || serverId == null){
                    $(".errors-checkin-form").html("Vui lòng chọn server");
                    $(".errors-checkin-form").show();
                    isPassed = false;
                }
                if(!isPassed){
                    return;
                }

                //Turn off error badge
                $(".errors-checkin-form").html("");
                $(".errors-checkin-form").hide();

                $(".errors-checkin-form").css('color', 'orange');
                $(".errors-checkin-form").html('Đang xử lý, vui lòng đợi trong giây lát...<img src="/assets/img/loader.gif" style="width: 16px;height: 16px;"/>');
                $(".errors-checkin-form").show();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-checkin')}}",
                    type: "POST",
                    dateType: "json",
                    data: {
                        server_id: serverId,
                        captcha: txtCaptcha,
                        player_id: playerId
                    },
                    success: function(t) {
                        let msg = t.msg;
                        $(".errors-checkin-form").css('color','green');
                        $(".errors-checkin-form").html(msg);
                        $(".errors-checkin-form").show();
                        $('#checkinFrm').trigger("reset");
                        reloadCaptcha();

                    },
                    error: function (t){
                        reloadCaptcha();
                        if (t.status == 422){
                            let errorMsg = "Điểm danh không thành công: </br>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += ` - ${value} </br>`;
                            });
                            $(".errors-checkin-form").css('color','red');
                            $(".errors-checkin-form").html(errorMsg);
                            $(".errors-checkin-form").show();
                        }
                        else if(t.status = 400){
                            $(".errors-checkin-form").css('color','red');
                            $(".errors-checkin-form").html(t.responseJSON.msg);
                            $(".errors-checkin-form").show();
                        }
                        $('#checkinFrm').trigger("reset");
                    }
                });
            });

        });
    </script>
@endpush

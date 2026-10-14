<div id="login">

    @auth('member')
        <div class="clearfix">
            <div style="float: left; max-width: 70%; line-height: 1; overflow: hidden;">
                <p style="font-size: 35px; color: #555; display: flex;flex-direction: column;align-items: flex-start;justify-content: flex-end;">
                    <small style="font-size: .5em;font-family: 'BreeSerif';margin: 0;">Chào mừng Gunner</small>
                    <span style="font-family: 'BreeSerif';margin: 0;">{{Auth::guard('member')->user()->Email}}</span>
                    <img style="margin: 0;" src="/assets/img/vip/vip{{Auth::guard('member')->user()->getVipLevel()}}_small.png" />
                </p>

            </div>
            <button class="login animElement slide-right" onclick="window.location='{{route('view-select-server')}}'"
                    style="float: right;font-family: BreeSerif">
                Play
            </button>
        </div>
        <div class="button-functional">
            <a class="item animElement slide-left" href="{{route('view-account').'?type=recharge'}}"
            style="display: inline-flex; background-color: rgb(245,98,0);font-family: 'BreeSerif'; border-color: rgb(250,83,0); justify-content: center; align-items: center;">
                <img src="/assets/svgs/sync-alt.svg" style="fill:white;" alt="nap_tien"> Nạp Tiền
            </a>
            <a class="item animElement slide-right" href="{{route('view-account')}}"
               style="display: inline-flex; text-align: center; background-color: #349517;font-family: 'BreeSerif'; border-color: #048507; align-items: center;">
                <img src="/assets/svgs/id-card.svg" alt="" style="margin-left: 11px;">
                Tài Khoản
            </a>
        </div>
        <div class="button-functional">
            <a class="item animElement slide-left" href="{{$config['launcher_download_url']}}"
               style="display: inline-flex; background-color: #4775f7;font-family: 'BreeSerif'; border-color: #4775f7; justify-content: center; align-items: center;">
                <img src="/assets/svgs/rocket.svg" alt=""> Launcher
            </a>
            <a class="item animElement slide-right" href="{{route('member-logout')}}"
               style="display: inline-flex; text-align: center; background-color: #F28A1a;font-family: 'BreeSerif'; border-color: #F28A1a; align-items: center;">
                <img src="/assets/svgs/sign-out-alt.svg" alt="" style="margin-left: 11px;">
                Đăng xuất
            </a>
        </div>
    @endauth
    @guest('member')
        @php
            $flashMessage = session('flashMessage');
            if (!empty($flashMessage)) {
                session(['flashMessage' => '']);
            }
        @endphp
        @if (!empty($flashMessage))
            <script>
                alert('{{ $flashMessage }}');
            </script>
        @endif
            <input class="animElement slide-left time-300" id="usernamelogin"
               placeholder="Tài Khoản" autocomplete="off">
        <input class="animElement slide-left time-300" id="passwordlogin" type="password"
               placeholder="Mật Khẩu" autocomplete="new-password">
        <button class="login animElement slide-right" id="loginbtn" type="submit">Login</button>
        <div class="footer" id="sign-in-error" style="display: none;text-align: center;font-family: 'BreeSerif'">
        </div>
        <div class="footer">
            <a class="left animElement just-show" href="{{route('view-forgot-password')}}" >Quên mật khẩu? </a>
            <a class="right animElement just-show" href="{{route('view-register')}}">Đăng ký</a>
        </div>
{{--        <div class="footer" style="display: flex">--}}
{{--            <a style="font-weight: bold" class="animElement just-show" href="{{route('view-transfer-account')}}">CẬP NHẬP TÀI KHOẢN</a>--}}
{{--        </div>--}}
        <div class="footer" style="display: flex">
            <a style="font-weight: bold" class="animElement just-show" href="{{route('view-login-puffin')}}">ĐĂNG NHẬP PUFFIN IOS</a>
        </div>
    @endguest

</div>

@push('js')
    <script type="text/javascript">
        $( document ).ready(function() {

            $('#usernamelogin').bind("keypress", function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    login();
                }
            });
            $('#passwordlogin').bind("keypress", function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    login();
                }
            });

            $("#loginbtn").click(function (){
                login();
            });

            function login(){
                $("#sign-in-error").css('color', '#ff7004');
                $("#sign-in-error").html(`<img src="/assets/img/loader.gif" style="width: 26px;height: 26px;"/><p style="font-weight: bold"> Đang đăng nhập, vui lòng đợi...</p>`);
                $("#sign-in-error").show();
                let username = $("#usernamelogin").val();
                let password = $("#passwordlogin").val();
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('auth-ajax-login')}}",
                    type: "post",
                    dateType: "json",
                    cache: false,
                    async: false,
                    data: {
                        username: username,
                        password: password
                    },
                    success: function(t) {
                        $("#sign-in-error").css('color', 'green');
                        $("#sign-in-error").html("<p>Đăng nhập thành công!</p><p>Trang sẽ tự động tải lại ngay.</p>");
                        $("#sign-in-error").show();

                        setTimeout(function() {
                            if (typeof t.ref != 'undefined') {
                                window.location = t.ref;
                                return;
                            }
                            window.location = "/"
                        }, 1e3)
                    },
                    error: function (t){
                        let statusCode = t.status;
                        if(statusCode == 401) {
                            $("#sign-in-error").css('color', 'red');
                            $("#sign-in-error").html("<p>"+t.responseJSON.msg+"</p>");
                            $("#passwordlogin").val("");
                        }
                        else if(statusCode == 422){
                            let errorMsg = "<p style='padding-bottom: 5px'>Lỗi:</p>";
                            $.each( t.responseJSON.errors, function( key, value) {
                                errorMsg += `<p> - ${value} </p>`;
                            });
                            $("#sign-in-error").css('color', 'red');
                            $("#sign-in-error").html(errorMsg);
                            $("#passwordlogin").val("");
                        }
                    }
                })
            }
        });

    </script>
@endpush

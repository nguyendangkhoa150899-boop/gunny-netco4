<div class="play-game p-a">
    <a href="#" class="playGame_btn js-btn-login" target="_blank"></a>
</div>

<div id="login">

    @auth('member')
        <div class="clearfix">
            <div style="float: left; max-width: 70%; line-height: 1; overflow: hidden;">
                <p style="font-size: 35px; color: #555;">
                    <small style="font-size: .5em;font-family: 'BreeSerif'">Chào mừng Gunner</small>
                    <span style="font-family: 'BreeSerif'">{{Auth::guard('member')->user()->Email}}</span>
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
        ĐĂNG NHẬP BẰNG PUFFIN IOS
        <form action="{{route('auth-login-puffin')}}" method="POST">
            {{csrf_field()}}
            <input class="animElement slide-left time-300" name="username"
                   placeholder="Tài Khoản" autocomplete="off">
            <input class="animElement slide-left time-300" name="password" type="password"
                   placeholder="Mật Khẩu" autocomplete="new-password">
            <button class="login animElement slide-right" id="loginbtn" type="submit">LOGIN</button>
            @if($errors->any())
                <div class="footer" id="sign-in-error" style="text-align: center;font-family: 'BreeSerif'">
                    {{$errors->first()}}
                </div>
            @endif
            <div class="footer">
                <a class="left animElement just-show" href="{{route('view-forgot-password')}}" >Quên mật khẩu?</a>
                <a class="right animElement just-show" href="{{route('view-register')}}">Đăng ký</a>
            </div>
{{--            <div class="footer" style="display: flex">--}}
{{--                <a style="font-weight: bold" class="animElement just-show" href="{{route('view-transfer-account')}}">CẬP NHẬP TÀI KHOẢN</a>--}}
{{--            </div>--}}
        </form>
    @endguest

</div>

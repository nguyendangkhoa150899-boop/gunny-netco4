@extends('layout.app')

@section('content')
    @include('home_banner')
    <div id="home">
        <aside id="content">
            <div class="content-container">
                <div class="news">
                    @foreach($articles as $article)
                        <div class="news-item">
                            <div class="image">
                                <img src="/{{ $article['image'] }}">
                            </div>
                            <div class="content">
                                <div class="title">
                                    <a href="/news/{{ $article['slug'] }}">{{ $article['title'] }}</a>
                                </div>
                                <div class="date">{{ date('d/m/Y', strtotime($article['date'])) }}</div>
                                <div class="description">
                                    {{ $article['description'] }}
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
                <div class="top">
                    <div class="title">Top 10 lực chiến</div>
                    <span class="toogle-select-top"><i class="fas fa-caret-down"></i></span>
                    <ul class="select-top">
                        <li data-title="Top 10 lực chiến" data-top="fightpower" class="hidden">Top 10 lực chiến</li>
                        <li data-title="Top 10 Online" data-top="online">Top 10 Online</li>
                        <li data-title="Top 10 Level" data-top="grade">Top 10 Level</li>
                        <li data-title="Top 10 Win" data-top="win">Top 10 Win</li>
                    </ul>
                    <table id="fightpower" class="showing">
                        <thead>
                            <tr>
                                <th style="width: 20px">#</th>
                                <th>Nhân vật</th>
                                <th style="width: 90px;">Lực chiến</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($toplc as $i => $top)
                                <tr>
                                    <td>{{ $i+1 }}</td>
                                    <td>{{ $top->NickName }}</td>
                                    <td>{{ $top->FightPower }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    <table id="online">
                        <thead>
                        <tr>
                            <th style="width: 20px">#</th>
                            <th>Nhân vật</th>
                            <th style="width: 70px;">Online</th>
                        </tr>
                        </thead>
                        <tbody>
                        @foreach($toponl as $i => $top)
                            <tr>
                                <td>{{ $i+1 }}</td>
                                <td>{{ $top->NickName }}</td>
                                <td>{{ $top->Onlinetime }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                    <table id="grade">
                        <thead>
                        <tr>
                            <th style="width: 20px">#</th>
                            <th>Nhân vật</th>
                            <th style="width: 90px;">Cấp</th>
                        </tr>
                        </thead>
                        <tbody>
                        @foreach($topgrade as $i => $top)
                            <tr>
                                <td>{{ $i+1 }}</td>
                                <td>{{ $top->NickName }}</td>
                                <td>{{ $top->Grade }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                    <table id="win">
                        <thead>
                        <tr>
                            <th style="width: 20px">#</th>
                            <th>Nhân vật</th>
                            <th style="width: 90px;">Trận</th>
                        </tr>
                        </thead>
                        <tbody>
                        @foreach($topwin as $i => $top)
                            <tr>
                                <td>{{ $i+1 }}</td>
                                <td>{{ $top->NickName }}</td>
                                <td>{{ $top->Win }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </aside>
        <div class="floater" @if ($loggedIn) style="top: calc(50% - 263px); background-image: url(/images/khungtruotbackground_withchoingay.png); height: 526px;" @endif>
            <div class="charger">
                <img src="/images/floatercharge.png" />
            </div>
            <div class="giftcode">
                <img src="/images/floatergifcode.png" />
            </div>
            @if (!$loggedIn)
                <div class="register" id="registerbutton">
                    <span>ĐĂNG KÝ</span>
                </div>
                <div class="login" id="loginbutton">
                    <span>ĐĂNG NHẬP</span>
                </div>
            @else
                <div class="register" id="accountbutton">
                    <span>TÀI KHOẢN</span>
                </div>
                <div class="login" id="groupbutton">
                    <span>GROUP</span>
                </div>
            @endif
            @if ($loggedIn)
                <div class="choingay">
                    <img src="/images/choingay.gif" alt="choingay">
                </div>
            @endif
        </div>
        <div class="overlay">
            <div class="loginform">
                <form class="loginform__form-group" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="loginform__form-group__inputs">
                        <input class="loginform__form-group__input" name="username" type="text" placeholder="Tài khoản"/>
                        <input class="loginform__form-group__input" name="password" type="password" placeholder="Mật khẩu"/>
                    </div>
                    <button class="loginform__form-group__button">

                    </button>
                </form>
                <div class="loginform__footer">
                    <a href="javascript:void(0)" onclick="returnForgotPass()">Quên mật khẩu?</a>
                    <a href="javascript:void(0)" onclick="returnRegister()">Đăng ký</a>
                </div>
                <div class="close">
                    <img src="/images/popupclosebutton.png" alt="close">
                </div>
            </div>
            <div class="registerform">
                <form class="registerform__form" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="registerform__form__form-group">
                        <label>Tài khoản *</label>
                        <input class="registerform__form__form-group__input" name="username" type="text"/>
                        <small style="color: #ff0000" class="username_error">&nbsp;</small>
                    </div>
                    <div class="registerform__form__inline-form-group">
                        <div class="registerform__form__form-group">
                            <label>Mật khẩu *</label>
                            <input class="registerform__form__form-group__input" name="password" type="password"/>
                            <small style="color: #ff0000" class="password_error">&nbsp;</small>
                        </div>
                        <div class="registerform__form__form-group">
                            <label>Nhập lại mật khẩu *</label>
                            <input class="registerform__form__form-group__input" name="repassword" type="password"/>
                            <small style="color: #ff0000" class="repassword_error">&nbsp;</small>
                        </div>
                    </div>
                    <div class="registerform__form__form-group">
                        <label>Email khôi phục mật khẩu/2FA</label>
                        <input class="registerform__form__form-group__input" name="email" type="email"/>
                        <small style="color: #ff0000" class="email_error">&nbsp;</small>
                    </div>
                    <div class="registerform__form__form-group captchainput">
                        {!! captcha_img() !!}
                        <input class="registerform__form__form-group__input" name="captcha" type="text" placeholder="Nhập kết quả của phép tính trên"/>
                        <small style="color: #ff0000" class="captcha_error">&nbsp;</small>
                    </div>
                    <div class="registerform__form__form-group">
                        <button class="registerform__form__form-group__button register" type="submit">Đăng ký tài khoản mới</button>
                        <button class="registerform__form__form-group__button back" type="button"><i class="fas fa-angle-left"></i> Trở lại đăng nhập</button>
                    </div>
                    <div class="close">
                        <img src="/images/popupclosebutton.png" alt="close">
                    </div>
                </form>
            </div>
            <div class="twofaform">
                <form class="twofaform__form-group" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="twofaform__form-group__inputs">
                        <label for="twofaformcode">Nhập mã số gồm 13 ký tự chúng tôi vừa gửi tới <br><b><i id="member_email"></i></b></label>
                        <input class="twofaform__form-group__input" name="twofaformcode" type="text" id="twofaformcode"/>
                    </div>
                </form>
                <div class="timeout">
                    Mã sẽ hết hiệu lực trong: <div class="code_timeout"><span class="minute"></span>:<span class="second"></span></div>
                </div>
                <div class="twofaform__footer">
                    <a href="javascript:void(0)">Không nhận được mã?</a>
                    <a href="javascript:void(0)" onclick="resend()">Gửi lại</a>
                </div>
                <div class="close">
                    <img src="/images/popupclosebutton.png" alt="close">
                </div>
            </div>
            <div class="forgotpassform">
                <form id="forgotpassform" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="forgotpass__form-group__inputs row">
                        <label for="forgotpasscode" class="col-3">Nhập email:</label>
                        <input class="forgotpass__form-group__input col-9" name="forgotpassemail" type="email" id="forgotpassemail"/>
                    </div>
                    <div class="forgotpass__form-group__inputs row captchainput">
                        <div class="col-3">{!! captcha_img() !!}</div>
                        <input class="forgotpass__form-group__input col-9" name="forgotpasscaptcha" type="text" id="forgotpasscaptcha" placeholder="Nhập kết quả của phép tính bên"/>
                    </div>
                    <div class="registerform__form__form-group">
                        <button class="forgotpass__form__form-group__button submit" type="submit">Gửi mã</button>
                        <button class="forgotpass__form__form-group__button back" type="button"><i class="fas fa-angle-left"></i> Trở lại đăng nhập</button>
                    </div>
                </form>
                <div class="close">
                    <img src="/images/popupclosebutton.png" alt="close">
                </div>
            </div>
            <div class="forgotpass2faform">
                <form class="forgotpass2faform__form-group" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="forgotpass2faform__form-group__inputs">
                        <label for="forgotpass2faformcode">Nhập mã số gồm 13 ký tự chúng tôi vừa gửi tới <br><b><i id="forgotpass2fa_member_email"></i></b></label>
                        <input class="forgotpass2faform__form-group__input" name="forgotpass2faformcode" type="text" id="forgotpass2faformcode"/>
                    </div>
                </form>
                <div class="timeout">
                    Mã sẽ hết hiệu lực trong: <div class="forgotpass2facode_timeout"><span class="forgotpass2faminute"></span>:<span class="forgotpass2fasecond"></span></div>
                </div>
                <div class="close">
                    <img src="/images/popupclosebutton.png" alt="close">
                </div>
            </div>
            <div class="forgotpass_password">
                <form class="forgotpass_password__form" method="post">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <div class="forgotpass_password__form__form-group">
                        <label for="forgotpass_password_password">Mật khẩu mới *</label>
                        <input class="forgotpass_password__form__form-group__input" name="password" type="password" id="forgotpass_password_password"/>
                        <small style="color: #ff0000" class="forgotpass_password_password_error">&nbsp;</small>
                    </div>
                    <div class="forgotpass_password__form__form-group">
                        <label for="forgotpass_password_repassword">Nhập lại mật khẩu *</label>
                        <input class="forgotpass_password__form__form-group__input" name="repassword" type="password" id="forgotpass_password_repassword"/>
                        <small style="color: #ff0000" class="forgotpass_password_repassword_error">&nbsp;</small>
                    </div>
                    <div class="forgotpass_password__form__form-group captchainput">
                        {!! captcha_img() !!}
                        <input class="forgotpass_password__form__form-group__input" name="captcha" type="text" placeholder="Nhập kết quả của phép tính trên"/>
                        <small style="color: #ff0000" class="forgotpass_password_captcha_error">&nbsp;</small>
                    </div>
                    <div class="forgotpass_password__form__form-group">
                        <button class="forgotpass_password__form__form-group__button register" type="submit">Đổi mật khẩu</button>
                    </div>
                    <div class="close">
                        <img src="/images/popupclosebutton.png" alt="close">
                    </div>
                </form>
            </div>
            @if (!empty($event))
                <div class="toppopup" style="background-image: url({{ $event->image }});">
                    <div class="close">
                        <img src="/images/popupclosebutton.png" alt="close">
                    </div>
                </div>
            @endif
        </div>
    </div>
@endsection

@section('custom_footer_js')
    <script>
        var showRegisterForm = function () {
            $('.registerform').css('display', 'flex').hide().fadeIn();
        }
        var hideRegisterForm = function (callback) {
            $('.registerform').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var showLoginForm = function () {
            $('.loginform').css('display', 'flex').hide().fadeIn();
        }
        var hideOverlay = function () {
            hideLoginForm();
            hideRegisterForm();
            hide2faForm();
            hideForgotPassForm();
            hideForgotPass2faForm();
            hideForgotPassPasswordForm();
            hideTopPopup();
            $('.overlay').fadeOut();
        }
        var hideLoginForm = function (callback) {
            $('.loginform').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var returnRegister = function () {
            hideLoginForm(showRegisterForm);
        }
        var returnForgotPass = function () {
            hideLoginForm(showForgotPassForm);
        }
        var show2faForm = function () {
            $('.twofaform').css('display', 'flex').hide().fadeIn();
        }
        var hide2faForm = function (callback) {
            if (typeof countdown != 'undefined') {
                clearInterval(countdown);
            }
            $("#twofaformcode").val('');
            $('.twofaform').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var showForgotPassForm = function () {
            $('.forgotpassform').css('display', 'flex').hide().fadeIn();
        }
        var hideForgotPassForm = function (callback) {
            if (typeof countdown != 'undefined') {
                clearInterval(countdown);
            }
            $('.forgotpassform').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var showForgotPass2faForm = function () {
            $('.forgotpass2faform').css('display', 'flex').hide().fadeIn();
        }
        var hideForgotPass2faForm = function (callback) {
            if (typeof forgotpasscountdown != 'undefined') {
                clearInterval(forgotpasscountdown);
            }
            $("#forgotpass2faformcode").val('');
            $('.forgotpass2faform').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var showForgotPassPasswordForm = function () {
            $('.forgotpass_password').css('display', 'flex').hide().fadeIn();
        }
        var hideForgotPassPasswordForm = function (callback) {
            $('.forgotpass_password').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        var showTopPopup = function () {
            $('.toppopup').css('display', 'flex').hide().fadeIn();
        }
        var hideTopPopup = function (callback) {
            $('.toppopup').fadeOut(300, function () {
                if (typeof callback == 'function') {
                    callback();
                }
            });
        }
        Number.prototype.pad = function(size) {
            var s = String(this);
            while (s.length < (size || 2)) {s = "0" + s;}
            return s;
        }
        var countdown;
        var minute;
        var second;
        var time_countdown = function (callback) {
            minute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
            second = {{ intval(env('2FA_CODE_EXPIRES', 120) % 60) }};
            $(".code_timeout .minute").text(minute.pad(2));
            $(".code_timeout .second").text(second.pad(2));
            if (typeof countdown != 'undefined') {
                clearInterval(countdown);
            }
            countdown = setInterval(function () {
                if (second == 0) {
                    if (minute == 0) {
                        clearInterval(countdown);
                        hideOverlay();
                        alertify.alert('Thông báo', 'Mã đã hết hiệu lực!');
                        if (typeof callback == 'function') {
                            callback();
                        }
                        return;
                    }
                    second = 60;
                    minute--;
                }
                second--;
                $(".code_timeout .minute").text(minute.pad(2));
                $(".code_timeout .second").text(second.pad(2));
            }, 1000);
        }
        var forgotpasscountdown;
        var forgotpassminute;
        var forgotpasssecond;
        var forgotpasstime_countdown = function () {
            forgotpassminute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
            forgotpasssecond = {{ env('2FA_CODE_EXPIRES', 120) % 60 }};
            $(".forgotpass2facode_timeout .forgotpass2faminute").text(forgotpassminute.pad(2));
            $(".forgotpass2facode_timeout .forgotpass2fasecond").text(forgotpasssecond.pad(2));
            if (typeof forgotpasscountdown != 'undefined') {
                clearInterval(forgotpasscountdown);
            }
            forgotpasscountdown = setInterval(function () {
                if (forgotpasssecond == 0) {
                    if (forgotpassminute == 0) {
                        clearInterval(forgotpasscountdown);
                        hideOverlay();
                        alertify.alert('Thông báo', 'Mã đã hết hiệu lực!');
                        return;
                    }
                    forgotpasssecond = 60;
                    forgotpassminute--;
                }
                forgotpasssecond--;
                $(".forgotpass2facode_timeout .forgotpass2faminute").text(forgotpassminute.pad(2));
                $(".forgotpass2facode_timeout .forgotpass2fasecond").text(forgotpasssecond.pad(2));
            }, 1000);
        }
        var resend = function () {
            showLoading();
            $.ajax({
                url: '/member/gui-lai-ma-login',
                type: 'get',
                dataType: 'json',
                success: function (rel) {
                    if (rel.success === true) {
                        time_countdown();
                        alertify.success(rel.message);
                        return false;
                    }
                    alertify.alert('Lỗi', rel.message);
                },
                error: function (rel) {
                    alertify.alert('Lỗi', 'Có lỗi khi xử lý, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                },
                complete: function () {
                    hideLoading();
                }
            });
        }
        $(document).ready(function() {
            $("#registerbutton").click(function() {
                $('.overlay').fadeIn(300, function () {
                    $(this).css('display', 'flex');
                    showRegisterForm();
                });
            });

            $("#loginbutton").click(function() {
                $('.overlay').fadeIn(300, function () {
                    $(this).css('display', 'flex');
                    showLoginForm();
                });
            });

            $(".overlay .close").click(function(e) {
                // if ($('.registerform').is(':visible')) {
                //     hideRegisterForm(hideOverlay);
                // } else if ($('.loginform').is(':visible')) {
                //     hideLoginForm(hideOverlay);
                // } else if ($(".twofaform").is(':visible')) {
                //     hide2faForm(hideOverlay);
                // } else if ($(".forgotpassform").is(':visible')) {
                //     hideForgotPassForm(hideOverlay);
                // }
                e.stopPropagation();
                hideOverlay();
            });
            $('.registerform__form__form-group__button.back').click(function () {
                hideRegisterForm(showLoginForm);
            });
            $('.forgotpass__form__form-group__button.back').click(function () {
                hideForgotPassForm(showLoginForm);
            });
            $('form.registerform__form').submit(function(e) {
                e.preventDefault();
                var username = $(this).find('input[name="username"]').val();
                var password = $(this).find('input[name="password"]').val();
                var repassword = $(this).find('input[name="repassword"]').val();
                var captcha = $(this).find('input[name="captcha"]').val();
                var email = $(this).find('input[name="email"]').val();
                var csrf = $(this).find('input[name="_token"]').val();
                var error = false;
                var not_email = false;
                if (!username) {
                    $(this).find('.username_error').text('Vui lòng nhập tài khoản để đăng ký!');
                    error = true;
                } else if (username.length < 5) {
                    $(this).find('.username_error').text('Tên tài khoản quá ngắn (tối thiểu 5 ký tự)!');
                    error = true;
                } else if (username.length > 255) {
                    $(this).find('.username_error').text('Tên tài khoản quá dài (tối đa 255 ký tự)!');
                    error = true;
                } else if (username.indexOf(' ') >= 0) {
                    $(this).find('.username_error').text('Tên tài khoản không được chứa khoảng trống');
                    error = true;
                } else {
                    $(this).find('.username_error').html('&nbsp;');
                }
                if (!password) {
                    $(this).find('.password_error').text('Vui lòng nhập mật khẩu!');
                    error = true;
                } else if (password.length < 5) {
                    $(this).find('.password_error').text('Mật khẩu quá ngắn (tối thiểu 6 ký tự)!');
                    error = true;
                } else if (password.length > 255) {
                    $(this).find('.password_error').text('Mật khẩu quá dài (tối đa 255 ký tự)!');
                    error = true;
                } else {
                    $(this).find('.password_error').html('&nbsp;');
                }
                if (repassword !== password) {
                    $(this).find('.repassword_error').text('Xác nhận mật khẩu không đúng!');
                    error = true;
                } else {
                    $(this).find('.repassword_error').html('&nbsp;');
                }
                if (!email) {
                    not_email = true;
                } else if (email.length > 255) {
                    $(this).find('.email_error').text('Email quá dài (tối đa 255 ký tự)!');
                    error = true;
                } else {
                    $(this).find('.email_error').html('&nbsp;');
                }
                if (!captcha) {
                    $(this).find('.captcha_error').text('Vui lòng nhập captcha!');
                    error = true;
                } else {
                    $(this).find('.captcha_error').html('&nbsp;');
                }
                if (error) {
                    return false;
                }
                var self = this;
                var doRequest = function () {
                    $.ajax({
                        url: '/member/register',
                        type: 'post',
                        dataType: 'json',
                        data: {
                            username: username,
                            password: password,
                            repassword: repassword,
                            email: email,
                            captcha: captcha,
                            _token: csrf
                        },
                        success: function (rel) {
                            if (rel.success) {
                                hideRegisterForm(function () {
                                    hideOverlay();
                                    alertify.success(rel.message);
                                });
                                $(self).trigger("reset");
                            } else {
                                alertify.error(rel.message);
                                if (rel.message == 'Tài khoản đã tồn tại') {
                                    $(self).find('.username_error').text(rel.message);
                                }
                            }
                        },
                        error: function (rel) {
                            $(self).find('.captcha_error').text('Sai captcha!');
                        },
                        complete: function () {
                            $.ajax({
                                url: '/member/refreshCaptcha',
                                type: 'get',
                                dataType: 'json',
                                success: function (rel) {
                                    if (typeof rel.url != 'undefined') {
                                        $(document).find('.captchainput img').attr("src", rel.url);
                                    } else {
                                        $(self).find('.captcha_error').text('Vui lòng tải lại trang!');
                                    }
                                }
                            });
                        }
                    });
                }
                if (not_email) {
                    alertify.confirm("Cảnh báo", "Không có email đồng nghĩa với việc bạn không thể khôi phục mật khẩu hoặc bật 2FA (Xác thực 2 lớp). Tuy nhiên, bạn có thể cập nhật thông tin email sau này. Bạn có muốn nhập email ngay bây giờ không?",
                        function(){
                            $('input[name="email"]').focus();
                            return;
                        },
                        function(){
                            doRequest();
                        }).set('labels', {ok:'Có, nhập email', cancel:'Đăng ký ngay'});
                } else {
                    doRequest();
                }
                return false;
            })
            $('form.loginform__form-group').submit(function (e) {
                e.preventDefault();
                var username = $(this).find('input[name="username"]').val();
                var password = $(this).find('input[name="password"]').val();
                var csrf = $(this).find('input[name="_token"]').val();
                if (!username && !password) {
                    alertify.alert('Lỗi!', 'Vui lòng nhập tài khoản và mật khẩu để đăng nhập!');
                    return false;
                }
                if (!username) {
                    alertify.alert('Lỗi!', 'Vui lòng nhập tài khoản để đăng nhập!');
                    return false;
                }
                if (!password) {
                    alertify.alert('Lỗi!', 'Vui lòng nhập mật khẩu để đăng nhập!');
                    return false;
                }
                var showLoadingTimeout = setTimeout(function () {
                    showLoading();
                }, 500);
                $.ajax({
                    url: '/member/login',
                    type: 'post',
                    dataType: 'json',
                    data: {username: username, password: password, _token: csrf},
                    success: function (rel) {
                        if (rel.success) {
                            if (parseInt(rel.success) === 2) {
                                hideLoginForm(function () {
                                    $("#member_email").text(rel.message);
                                    show2faForm();
                                    time_countdown();
                                });
                                return;
                            }
                            alertify.success(rel.message);
                            setTimeout(function () {
                                location.href = '/';
                            }, 1000);
                            return false;
                        }
                        alertify.alert('Lỗi', rel.message);
                    },
                    error: function (rel) {
                        alertify.alert('Lỗi', 'Có lỗi khi tiến hành đăng nhập, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                    },
                    complete: function () {
                        clearTimeout(showLoadingTimeout);
                        hideLoading();
                    }
                })
            });

            $("#accountbutton").click(function () {
                location.href = '/tai-khoan';
            });
            var group_link = '{{ \App\Models\Setting::get('group-link') }}';
            $("#groupbutton").click(function () {
                if (group_link) {
                    window.open(group_link, '_blank');
                }
            });

            @if (!$loggedIn)
                $(".charger").click(function () {
                    //login
                    $('.overlay').fadeIn(300, function () {
                        $(this).css('display', 'flex').hide().fadeIn();
                        showLoginForm();
                    });
                });
                $(".giftcode").click(function () {
                    //login
                    $('.overlay').fadeIn(300, function () {
                        $(this).css('display', 'flex').hide().fadeIn();
                        showLoginForm();
                    });
                });
            @else
                $(".charger").click(function () {
                    window.location.href = '/tai-khoan/nap-coin';
                });
                $(".giftcode").click(function () {
                    window.location.href = '/tai-khoan/giftcode';
                });
            @endif

            $(".top .title").click(function () {
                $(".top .select-top").toggleClass('showing');
            });
            $(".top .select-top li").click(function () {
                $(".top .select-top li").removeClass('hidden');
                $(this).addClass('hidden');
                $(".top .select-top").toggleClass('showing');
                var title = $(this).data('title');
                var top = $(this).data('top');
                $(".top .title").text(title);
                $(".top table").removeClass('showing');
                $("#"+top).addClass('showing');
            });
            var codesending = false;
            $("#twofaformcode").on('input', function () {
                var code = $(this).val();
                if (code.length == 13 && !codesending) {
                    codesending = true;
                    var showLoadingTimeout = setTimeout(function () {
                        showLoading();
                    }, 500);
                    $.ajax({
                        url: '/member/nhap-ma-login',
                        type: 'post',
                        dataType: 'json',
                        data: {code: code, _token: '{{ csrf_token() }}'},
                        success: function (rel) {
                            if (rel.success) {
                                alertify.success(rel.message);
                                if (typeof countdown != 'undefined') {
                                    clearInterval(countdown);
                                }
                                setTimeout(function () {
                                    location.href = '/';
                                }, 1000);
                                return false;
                            }
                            alertify.alert('Lỗi', rel.message);
                        },
                        error: function (rel) {
                            alertify.alert('Lỗi', 'Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                        },
                        complete: function () {
                            codesending = false;
                            clearTimeout(showLoadingTimeout);
                            hideLoading();
                            hideOverlay();
                        }
                    });
                }
            });

            $("#forgotpassform").submit(function (e) {
                e.preventDefault();
                var csrf = $(this).find('input[name="_token"]').val();
                var email = $("#forgotpassemail").val();
                var captcha = $("#forgotpasscaptcha").val();
                if (!email || !captcha) {
                    alertify.alert("Vui lòng nhập email và captcha!");
                    return;
                }
                var outLoading = setTimeout(function () {
                    showLoading();
                }, 500);
                $.ajax({
                    url: '/member/quen-mat-khau',
                    type: 'post',
                    dataType: 'json',
                    data: {email: email, captcha: captcha, _token: csrf},
                    success: function (rel) {
                        if (rel.success) {
                            $("#forgotpass2fa_member_email").text(rel.message);
                            hideForgotPassForm(showForgotPass2faForm);
                            forgotpasstime_countdown();
                            return;
                        }
                        alertify.alert(rel.message);
                    },
                    error: function (rel) {
                        alertify.alert('Lỗi', 'Sai captcha!');
                    },
                    complete: function () {
                        clearTimeout(outLoading);
                        hideLoading();
                        $.ajax({
                            url: '/member/refreshCaptcha',
                            type: 'get',
                            dataType: 'json',
                            success: function (rel) {
                                if (typeof rel.url != 'undefined') {
                                    $(document).find('.captchainput img').attr("src", rel.url);
                                }
                            }
                        });
                    }
                })
            });
            var forgotpass2facodesending = false
            $("#forgotpass2faformcode").on('input', function (e) {
                var code = $(this).val();
                if (code.length == 13 && !forgotpass2facodesending) {
                    forgotpass2facodesending = true;
                    var showLoadingTimeout = setTimeout(function () {
                        showLoading();
                    }, 500);
                    $.ajax({
                        url: '/member/nhap-ma-khoi-phuc-mat-khau',
                        type: 'post',
                        dataType: 'json',
                        data: {code: code, _token: '{{ csrf_token() }}'},
                        success: function (rel) {
                            if (rel.success) {
                                if (typeof forgotpasscountdown != 'undefined') {
                                    clearInterval(forgotpasscountdown);
                                }
                                hideForgotPass2faForm(showForgotPassPasswordForm);
                                return false;
                            }
                            alertify.alert('Lỗi', rel.message);
                        },
                        error: function (rel) {
                            alertify.alert('Lỗi', 'Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                        },
                        complete: function () {
                            forgotpass2facodesending = false;
                            clearTimeout(showLoadingTimeout);
                            hideLoading();
                            // hideOverlay();
                        }
                    });
                }
            });
            $(".forgotpass_password__form").submit(function (e) {
                e.preventDefault();
                var password = $(this).find('input[name="password"]').val();
                var repassword = $(this).find('input[name="repassword"]').val();
                var captcha = $(this).find('input[name="captcha"]').val();
                var csrf = $(this).find('input[name="_token"]').val();
                var error = false;

                if (!password) {
                    $(this).find('.forgotpass_password_password_error').text('Vui lòng nhập mật khẩu!');
                    error = true;
                } else if (password.length < 5) {
                    $(this).find('.forgotpass_password_password_error').text('Mật khẩu quá ngắn (tối thiểu 6 ký tự)!');
                    error = true;
                } else if (password.length > 255) {
                    $(this).find('.forgotpass_password_password_error').text('Mật khẩu quá dài (tối đa 255 ký tự)!');
                    error = true;
                } else {
                    $(this).find('.forgotpass_password_password_error').html('&nbsp;');
                }
                if (repassword !== password) {
                    $(this).find('.forgotpass_password_repassword_error').text('Xác nhận mật khẩu không đúng!');
                    error = true;
                } else {
                    $(this).find('.forgotpass_password_repassword_error').html('&nbsp;');
                }
                if (!captcha) {
                    $(this).find('.forgotpass_password_captcha_error').text('Vui lòng nhập captcha!');
                    error = true;
                } else {
                    $(this).find('.forgotpass_password_captcha_error').html('&nbsp;');
                }
                if (error) {
                    return false;
                }
                var showLoadingTimeout = setTimeout(function () {
                    showLoading();
                }, 500);
                $.ajax({
                    url: '/member/doi-mat-khau',
                    type: 'post',
                    dataType: 'json',
                    data: {password: password, repassword: repassword, captcha: captcha, _token: csrf},
                    success: function (rel) {
                        if (rel.success) {
                            alertify.success(rel.message);
                            setTimeout(function () {
                                window.location.href = '/';
                            }, 1000);
                            return false;
                        }
                        alertify.alert('Lỗi', rel.message);
                    },
                    error: function (rel) {
                        alertify.alert('Lỗi', 'Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                    },
                    complete: function () {
                        clearTimeout(showLoadingTimeout);
                        hideLoading();
                        // hideOverlay();
                        $.ajax({
                            url: '/member/refreshCaptcha',
                            type: 'get',
                            dataType: 'json',
                            success: function (rel) {
                                if (typeof rel.url != 'undefined') {
                                    $(document).find('.captchainput img').attr("src", rel.url);
                                }
                            }
                        });
                    }
                });
            });

            $(".choingay").click(function () {
                window.location.href = '/play/1001';
            });
            @if (!empty($event))
                $('.overlay').fadeIn(300, function () {
                    $(this).css('display', 'flex');
                    showTopPopup();
                });
                $(".toppopup").click(function () {
                    window.location.href = '/su-kien/{{ $event->slug }}';
                });
            @endif
        });

    </script>
@endsection

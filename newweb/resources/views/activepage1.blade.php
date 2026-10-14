<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <title>Gogun.vn - Tìm lại ký ức Gà</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/css/iCielSoupOfJustice.css" />
    <link rel="stylesheet" href="/vendor/bootstrap-5.0.1-dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/vendor/fontawesome-free-5.15.3-web/css/all.min.css" />
    <link rel="stylesheet" href="/css/alertify.min.css" />
    <link rel="stylesheet" href="/css/themes/default.min.css" />
    <link rel="stylesheet" href="/css/activepage1.css?v=20210729014200" />
    <link rel="icon" type="image/png" href="/favicon.png">
    <script src="/vendor/bootstrap-5.0.1-dist/js/bootstrap.min.js"></script>
    <script src="/js/alertify.min.js"></script>
    <script src="/js/jquery-3.6.0.min.js"></script>
    <script>
        var showLoading = function () {
            $(".overlay-loading").css('display', 'flex').hide().fadeIn();
        }
        var hideLoading = function () {
            $(".overlay-loading").fadeOut();
        }
        var showOverlay = function () {
            $(".overlay").fadeIn();
        }
        var hideOverlay = function () {
            $(".overlay").fadeOut();
        }
        var showLoginForm = function () {
            $(".form-login").fadeIn(300);
        }
        var hideLoginForm = function (callback) {
            $(".form-login").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        var showRegisterForm = function () {
            $(".form-register").fadeIn(300);
        }
        var hideRegisterForm = function (callback) {
            $(".form-register").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        var showForgotPassForm = function () {
            $(".form-forgot-pass").fadeIn(300);
        }
        var hideForgotPassForm = function (callback) {
            $(".form-forgot-pass").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        var showForgotPass2faForm = function () {
            $(".form-forgot-pass-2fa").fadeIn(300);
        }
        var hideForgotPass2faForm = function (callback) {
            $(".form-forgot-pass-2fa").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        var showLogin2faForm = function () {
            $(".form-login-2fa").fadeIn(300);
        }
        var hideLogin2faForm = function (callback) {
            $(".form-login-2fa").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        var showForgotPassPasswordForm = function () {
            $(".form-forgot-pass-pass").fadeIn(300);
        }
        var hideForgotPassPasswordForm = function (callback) {
            $(".form-forgot-pass-pass").fadeOut(300, function () {
                if (typeof callback == "function") {
                    callback();
                }
            });
        }
        Number.prototype.pad = function(size) {
            var s = String(this);
            while (s.length < (size || 2)) {s = "0" + s;}
            return s;
        }
        $(document).ready(function () {
            setInterval(function () {
                $('.taigame-text').toggleClass('hover1');
            }, 1000);

            $(".taigame").click(function () {
                $(".overlay").fadeIn(300, function () {
                    showLoginForm();
                });
                window.location.href = '/GogunClient.rar';
            });

            $("#register_link").click(function () {
                hideLoginForm(showRegisterForm);
            });

            $("#btn_return_login").click(function () {
                hideRegisterForm(showLoginForm);
            });

            $("#forgotpass_link").click(function () {
                hideLoginForm(showForgotPassForm);
            });

            $("#btn_return_login_forgot_pass").click(function () {
                hideForgotPassForm(showLoginForm);
            });

            $("#btn_return_login_forgot_pass_2fa").click(function () {
                hideForgotPass2faForm(showLoginForm);
            });

            $("#loginform button").click(function () {
                $("#loginform").submit();
            });

            $("#btn_register").click(function () {
                $("#registerform").submit();
            });

            $("#btn_forgot_pass").click(function () {
                $("#forgotpassform").submit();
            });

            $("#btn_forgot_pass_2fa").click(function () {
                $("#forgotpass2faform").submit();
            });

            $("#btn_forgot_pass_password").click(function () {
                $("#forgotpasspassform").submit();
            });

            $("#btn_login_2fa").click(function () {
                $("#login2faform").submit();
            });

            var countdown;
            var minute;
            var second;
            var time_countdown = function (callback) {
                minute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
                second = {{ intval(env('2FA_CODE_EXPIRES', 120) % 60) }};
                $(".minute").text(minute.pad(2));
                $(".second").text(second.pad(2));
                if (typeof countdown != 'undefined') {
                    clearInterval(countdown);
                }
                countdown = setInterval(function () {
                    if (second == 0) {
                        if (minute == 0) {
                            clearInterval(countdown);
                            hideLogin2faForm(function () {
                                hideOverlay();
                            });
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
                    $(".minute").text(minute.pad(2));
                    $(".second").text(second.pad(2));
                }, 1000);
            }
            var forgotpasscountdown;
            var forgotpassminute;
            var forgotpasssecond;
            var forgotpasstime_countdown = function () {
                forgotpassminute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
                forgotpasssecond = {{ env('2FA_CODE_EXPIRES', 120) % 60 }};
                $(".forgotpass2faminute").text(forgotpassminute.pad(2));
                $(".forgotpass2fasecond").text(forgotpasssecond.pad(2));
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
                    $(".forgotpass2faminute").text(forgotpassminute.pad(2));
                    $(".forgotpass2fasecond").text(forgotpasssecond.pad(2));
                }, 1000);
            }

            var resend = function (callback) {
                showLoading();
                $.ajax({
                    url: '/member/gui-lai-ma-login',
                    type: 'get',
                    dataType: 'json',
                    success: function (rel) {
                        if (rel.success === true) {
                            if (typeof callback == 'function') {
                                callback();
                            }
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

            $("#loginform").on('submit', function (e) {
                e.preventDefault();
                var username = $("#login_username").val();
                var password = $("#login_password").val();
                var csrf = '{{ csrf_token() }}';

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
                                    $("#login_2fa_email").text(rel.message);
                                    showLogin2faForm();
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

            $('#registerform').submit(function(e) {
                e.preventDefault();
                var username = $('#register_username').val();
                var password = $('#register_password').val();
                var repassword = $('#register_repassword').val();
                var captcha = $('#register_captcha').val();
                var email = $('#register_email').val();
                var csrf = '{{ csrf_token() }}';
                var error = false;
                var not_email = false;
                if (!username) {
                    alertify.alert('Vui lòng nhập tài khoản để đăng ký!');
                    error = true;
                } else if (username.length < 5) {
                    alertify.alert('Tên tài khoản quá ngắn (tối thiểu 5 ký tự)!');
                    error = true;
                } else if (username.length > 255) {
                    alertify.alert('Tên tài khoản quá dài (tối đa 255 ký tự)!');
                    error = true;
                } else if (username.indexOf(' ') >= 0) {
                    alertify.alert('Tên tài khoản không được chứa khoảng trống');
                    error = true;
                }
                if (!password) {
                    alertify.alert('Vui lòng nhập mật khẩu!');
                    error = true;
                } else if (password.length < 5) {
                    alertify.alert('Mật khẩu quá ngắn (tối thiểu 6 ký tự)!');
                    error = true;
                } else if (password.length > 255) {
                    alertify.alert('Mật khẩu quá dài (tối đa 255 ký tự)!');
                    error = true;
                }
                if (repassword !== password) {
                    alertify.alert('Xác nhận mật khẩu không đúng!');
                    error = true;
                }
                if (!email) {
                    not_email = true;
                } else if (email.length > 255) {
                    alertify.alert('Email quá dài (tối đa 255 ký tự)!');
                    error = true;
                }
                if (!captcha) {
                    alertify.alert('Vui lòng nhập captcha!');
                    error = true;
                }
                if (error) {
                    return false;
                }
                var self = this;
                var doRequest = function () {
                    var showLoadingTimeout = setTimeout(function () {
                        showLoading();
                    }, 500);
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
                                    showLoginForm();
                                    alertify.success(rel.message);
                                });
                                $(self).trigger("reset");
                            } else {
                                alertify.error(rel.message);
                                if (rel.message == 'Tài khoản đã tồn tại') {
                                    alertify.alert(rel.message);
                                }
                            }
                        },
                        error: function (rel) {
                            alertify.alert('Sai captcha!');
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
                                        alertify.alert('Vui lòng tải lại trang!');
                                    }
                                }
                            });
                            clearTimeout(showLoadingTimeout);
                            hideLoading();
                        }
                    });
                }
                if (not_email) {
                    // alertify.confirm("Cảnh báo", "Không có email đồng nghĩa với việc bạn không thể khôi phục mật khẩu hoặc bật 2FA (Xác thực 2 lớp). Tuy nhiên, bạn có thể cập nhật thông tin email sau này. Bạn có muốn nhập email ngay bây giờ không?",
                    //     function(){
                    //         $('input[name="email"]').focus();
                    //         return;
                    //     },
                    //     function(){
                            doRequest();
                        // }).set('labels', {ok:'Có, nhập email', cancel:'Đăng ký ngay'});
                } else {
                    doRequest();
                }
                return false;
            });

            $("#forgotpassform").submit(function (e) {
                e.preventDefault();
                var csrf = '{{ csrf_token() }}';
                var email = $("#forgot_pass_email").val();
                var captcha = $("#forgot_pass_captcha").val();
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
                            $("#email-2fa").text(rel.message);
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

            $("#forgotpass2faform").submit(function (e) {
                e.preventDefault();
                var code = $("#forgot_pass_2fa_code").val();
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
                        clearTimeout(showLoadingTimeout);
                        hideLoading();
                        // hideOverlay();
                    }
                });
            });

            $("#forgotpasspassform").submit(function (e) {
                e.preventDefault();
                var password = $('#forgot_pass_pass_password').val();
                var repassword = $('#forgot_pass_pass_repassword').val();
                var captcha = $('#forgot_pass_pass_captcha').val();
                var csrf = '{{ csrf_token() }}';
                var error = false;

                if (!password) {
                    alertify.alert('Vui lòng nhập mật khẩu!');
                    error = true;
                } else if (password.length < 5) {
                    alertify.alert('Mật khẩu quá ngắn (tối thiểu 6 ký tự)!');
                    error = true;
                } else if (password.length > 255) {
                    alertify.alert('Mật khẩu quá dài (tối đa 255 ký tự)!');
                    error = true;
                }
                if (repassword !== password) {
                    alertify.alert('Xác nhận mật khẩu không đúng!');
                    error = true;
                }
                if (!captcha) {
                    alertify.alert('Vui lòng nhập captcha!');
                    error = true;
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
                            hideForgotPassPasswordForm(showLoginForm);
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

            $("#btn_resend_login_2fa").click(function (e) {
                e.preventDefault();
                resend(time_countdown);
            });

            $("#login2faform").submit(function (e) {
                e.preventDefault();
                var code = $("#login_2fa_code").val();
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
                        clearTimeout(showLoadingTimeout);
                        hideLoading();
                    }
                });
            });
        });
    </script>
</head>
<body>
    <div class="overlay-loading">
        <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
    </div>
    <div class="left-side">
        <div class="logo">
            <img src="/images/Final-Logo.png">
        </div>
        <div class="mainnv">
            <img src="/images/activepage1/Main.png">
        </div>
    </div>
    <div class="right-side">
        <div class="gach">
            <img src="/images/activepage1/ga_CH.png">
        </div>
        <div class="maintext">
            <img src="/images/activepage1/Text.png">
        </div>
        <div class="nv-taigame">
            <div class="taigame">
                <div class="taigame-text"></div>
            </div>
            <div class="nv">
                <img src="/images/activepage1/nhanvat.png">
            </div>
        </div>
        <div class="tinhnang">
            <img src="/images/activepage1/tinhnang.png">
        </div>
    </div>
    <div class="overlay">
        <div class="form-login formbg">
            <label class="form-title form-title-gradient">ĐĂNG NHẬP</label>
            <form id="loginform">
                <input type="text" name="username" id="login_username" placeholder="Tên Đăng Nhập">
                <input type="password" name="password" id="login_password" placeholder="Mật Khẩu">
                <button type="button">ĐĂNG NHẬP</button>
            </form>
            <div class="footer">
                <p><a href="javascript:void(0)" id="forgotpass_link">Quên mật khẩu</a></p>
                <p><a href="javascript:void(0)" id="register_link">Đăng ký</a></p>
            </div>
        </div>
        <div class="form-register formbg" style="display:none">
            <label class="form-title form-title-gradient">ĐĂNG KÝ</label>
            <form id="registerform">
                <input type="text" name="username" id="register_username" placeholder="Tên Đăng Nhập">
                <div class="row">
                    <div class="col-6">
                        <input type="password" name="password" id="register_password" placeholder="Mật Khẩu">
                    </div>
                    <div class="col-6">
                        <input type="password" name="repassword" id="register_repassword" placeholder="Nhập lại mật khẩu">
                    </div>
                </div>
                <input type="email" name="email" id="register_email" placeholder="Email khôi phục mật khẩu">
                <div class="row">
                    <div class="col-4 captchainput">
                        {!! captcha_img() !!}
                    </div>
                    <div class="col-8">
                        <input type="text" name="captcha" id="register_captcha" placeholder="Nhập kết quả phép tính bên">
                    </div>
                </div>
                <div class="row">
                    <div class="col-6 text-right">
                        <button type="button" id="btn_register">Đăng Ký</button>
                    </div>
                    <div class="col-6 text-left">
                        <button type="button" id="btn_return_login"><i class="fas fa-angle-left"></i> Đăng Nhập</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="form-forgot-pass formbg" style="display:none">
            <label class="form-title form-title-gradient">KHÔI PHỤC MẬT KHẨU</label>
            <form id="forgotpassform">
                <input type="email" name="forgot_pass_email" id="forgot_pass_email" placeholder="Email khôi phục mật khẩu">
                <div class="row">
                    <div class="col-4 captchainput">
                        {!! captcha_img() !!}
                    </div>
                    <div class="col-8">
                        <input type="text" name="captcha" id="forgot_pass_captcha" placeholder="Nhập kết quả phép tính bên">
                    </div>
                </div>
                <div class="row">
                    <div class="col-6 text-right">
                        <button type="button" id="btn_forgot_pass">Khôi Phục</button>
                    </div>
                    <div class="col-6 text-left">
                        <button type="button" id="btn_return_login_forgot_pass"><i class="fas fa-angle-left"></i> Đăng Nhập</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="form-login-2fa formbg" style="display:none">
            <label class="form-title form-title-gradient">XÁC THỰC 2 LỚP</label>
            <form id="login2faform">
                <p>Nhập mã xác thực chúng tôi đã gửi tới<br><span id="login_2fa_email"></span></p>
                <input type="text" name="login_2fa_code" id="login_2fa_code">
                <div class="timeout">
                    Mã sẽ hết hiệu lực trong: <span class="minute"></span>:<span class="second"></span>
                    <br><br>
                </div>
                <div class="row">
                    <div class="col-6 text-right">
                        <button type="button" id="btn_login_2fa">Đăng Nhập</button>
                    </div>
                    <div class="col-6 text-left">
                        <button type="button" id="btn_resend_login_2fa">Gửi lại mã</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="form-forgot-pass-2fa formbg" style="display:none">
            <label class="form-title form-title-gradient">KHÔI PHỤC MẬT KHẨU</label>
            <form id="forgotpass2faform">
                <p>Nhập mã khôi phục mật khẩu chúng tôi đã gửi tới<br><span id="email-2fa"></span></p>
                <input type="text" name="forgot_pass_2fa_code" id="forgot_pass_2fa_code">
                <div class="timeout">
                    Mã sẽ hết hiệu lực trong: <span class="forgotpass2faminute"></span>:<span class="forgotpass2fasecond"></span>
                    <br><br>
                </div>
                <button type="button" id="btn_forgot_pass_2fa">Khôi Phục</button>
            </form>
        </div>
        <div class="form-forgot-pass-pass formbg" style="display:none">
            <label class="form-title form-title-gradient">KHÔI PHỤC MẬT KHẨU</label>
            <form id="forgotpasspassform">
                <input type="password" name="forgot_pass_pass_password" id="forgot_pass_pass_password" placeholder="Mật Khẩu Mới">
                <input type="password" name="forgot_pass_pass_repassword" id="forgot_pass_pass_repassword" placeholder="Nhập Lại Mật Khẩu Mới">
                <div class="row">
                    <div class="col-4 captchainput">
                        {!! captcha_img() !!}
                    </div>
                    <div class="col-8">
                        <input type="text" name="captcha" id="forgot_pass_pass_captcha" placeholder="Nhập kết quả phép tính bên">
                    </div>
                </div>
                <button type="button" id="btn_forgot_pass_password">Đổi mật khẩu</button>
            </form>
        </div>
    </div>
</body>
</html>

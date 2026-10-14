@extends('layout.account')

@section('content')
    <h3>THÔNG TIN TÀI KHOẢN</h3>
    <table>
        <tr>
            <td style="width: 200px">Tên tài khoản:</td>
            <td>{{ $member->Email }}</td>
        </tr>
        <tr>
            <td>Coin:</td>
            <td>{{ number_format($member->Money) }}</td>
        </tr>
        <tr>
            <td>Email:</td>
            <td><span id="email_display">@if (!$member['VerifiedEmail'])<del>@endif{{ $member->Fullname ?? 'Chưa cập nhật' }}@if (!$member['VerifiedEmail'])</del>@endif</span> &nbsp; <i class="fas fa-edit" title="Thay đổi địa chỉ email" id="email_edit_button"></i></td>
        </tr>
        <tr>
            <td>Xác thực 2 lớp (2FA):</td>
            <td><input type="checkbox" id="2fa_switch" class="switch" {{ $member['2fa']?'checked':'' }} {{ $member['VerifiedEmail']?'':'disabled' }}/><label for="2fa_switch" class="switch_label"></label></td>
        </tr>
    </table>
    <div class="logout">
        @if (!$member['VerifiedEmail'] && !empty($member->Fullname))
            <button type="button" class="btn btn-primary" id="verify_email_button">Xác thực Email</button>
        @endif
        <a href="/member/logout" class="btn btn-warning">Thoát</a>
    </div>
    <div class="account-form-area" style="display: none;">
        <h5>Thay đổi địa chỉ email</h5>
        <div class="password_required_for_email_change row">
            <label for="password" class="col-4">Mật khẩu hiện tại:</label>
            <input class="col-8" style="width: 50%" type="password" name="password" id="password">
        </div>
        <div class="row" >
            <label for="email" class="col-4">Email:</label>
            <input class="col-8" style="width: 50%" type="email" name="email" id="email">
        </div>
        <div class="row" >
            <div class="col-2"><button type="button" class="btn btn-primary" onclick="dorequest()">Xác nhận</button></div>
            <div class="col-2"><button type="button" class="btn btn-danger" onclick="norequest()">Hủy bỏ</button></div>
            <div class="col-4">&nbsp;</div>
            <div class="col-4">&nbsp;</div>
        </div>
    </div>
    <div class="account_index_overlay">
        <div class="tfaform">
            <div class="tfaform__form-group__inputs">
                <label for="code">Nhập mã gồm 13 ký tự mà chúng tôi đã gửi tới<br><b><i>{{ $member->Fullname }}</i></b></label>
                <input class="tfaform__form-group__input" name="code" id="code"/>
            </div>
            <div class="timeout">
                Mã sẽ hết hiệu lực trong: <div class="code_timeout"><span class="minute"></span>:<span class="second"></span></div>
            </div>
            <div class="tfaform__footer">
                Không nhận được mã? &nbsp;<a href="javascript:void(0)" id="resendcode">Gửi lại</a>
            </div>
            <div class="close">
                <img src="/images/popupclosebutton.png" alt="close">
            </div>
        </div>
        <div class="toggletfaform">
            <div class="toggletfaform__form-group__inputs">
                <label for="code">Nhập mã gồm 13 ký tự mà chúng tôi đã gửi tới<br><b><i>{{ $member->Fullname }}</i></b></label>
                <input class="toggletfaform__form-group__input" name="code" id="toggletfacode"/>
            </div>
            <div class="timeout">
                Mã sẽ hết hiệu lực trong: <div class="code_timeout"><span class="minute"></span>:<span class="second"></span></div>
            </div>
            <div class="toggletfaform__footer">
                Không nhận được mã? &nbsp;<a href="javascript:void(0)" id="toggletfa_resendcode">Gửi lại</a>
            </div>
            <div class="close">
                <img src="/images/popupclosebutton.png" alt="close">
            </div>
        </div>
        <div class="verifyemail">
            <div class="verifyemail__form-group__inputs">
                <label for="code">Nhập mã gồm 13 ký tự mà chúng tôi đã gửi tới<br><b><i>{{ $member->Fullname }}</i></b></label>
                <input class="verifyemail__form-group__input" name="code" id="verifyemailcode"/>
            </div>
            <div class="timeout">
                Mã sẽ hết hiệu lực trong: <div class="code_timeout"><span class="minute"></span>:<span class="second"></span></div>
            </div>
            <div class="verifyemail__footer">
                Không nhận được mã? &nbsp;<a href="javascript:void(0)" id="verifyemail_resendcode">Gửi lại</a>
            </div>
            <div class="close">
                <img src="/images/popupclosebutton.png" alt="close">
            </div>
        </div>
    </div>
@endsection

@section('custom_footer_js')
    <script>
        Number.prototype.pad = function(size) {
            var s = String(this);
            while (s.length < (size || 2)) {s = "0" + s;}
            return s;
        }
        var old_email;
        var csrf = '{{ csrf_token() }}';
        var norequest = function () {
            $("#email_display").text(old_email);
            $("#password").val('');
            $("#email").val('');
            $(".account-form-area").hide();
            $("#email_edit_button").show();
        }
        var dorequest = function () {
            showLoading();
            var email = $("#email").val();
            var password = $("#password").val();
            if (!email || !password) {
                alertify.alert('Cảnh báo', 'Vui lòng nhập Email và password để thay đổi email');
                return;
            }
            $.ajax({
                url: '/tai-khoan/doi-email',
                type: 'post',
                dataType: 'json',
                data: {email: email, password: password, _token: csrf},
                success: function (rel) {
                    if (rel.success === true) {
                        alertify.success(rel.message);
                        $("#password").val('');
                        $("#email").val('');
                        $(".account-form-area").hide();
                        $("#email_display").text(email);
                        $("#email_edit_button").show();
                        return false;
                    } else if (parseInt(rel.success) === 2) {
                        alertify.success(rel.message);
                        $(".account_index_overlay")
                            .css('display', 'flex')
                            .hide()
                            .fadeIn(100, function () {
                                $(".tfaform").css('display', 'flex').hide().fadeIn();
                                time_countdown();
                            });
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
        var email_verified = {{ $member['VerifiedEmail']?'true':'false' }};
        var countdown;
        var minute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
        var second = {{ intval(env('2FA_CODE_EXPIRES', 120) % 60) }};
        var hideOverlay = function () {
            //clear all timeout
            var id = window.setTimeout(function() {}, 0);
            while (id--) {
                window.clearTimeout(id);
            }
            //clear all interval
            var interval_id = window.setInterval("", 9999);
            for (var i = 1; i <= interval_id; i++) {
                window.clearInterval(i);
            }
            $("#code, #toggletfacode").val('');
            $(".account_index_overlay > div").fadeOut(100, function () {
                $(".account_index_overlay").fadeOut();
            });
        }
        var showOverlay = function () {
            $(".account_index_overlay").css('display', 'flex').hide().fadeIn();
        }
        var showToggle2faForm = function () {
            showOverlay();
            $(".toggletfaform").css('display', 'flex').hide().fadeIn();
        }
        var showVerifyEmailForm = function () {
            showOverlay();
            $(".verifyemail").css('display', 'flex').hide().fadeIn();
        }
        var time_countdown = function () {
            minute = {{ intval(env('2FA_CODE_EXPIRES', 120) / 60) }};
            second = {{ intval(env('2FA_CODE_EXPIRES', 120) % 60) }};
            $(".code_timeout .minute").text(minute.pad(2));
            $(".code_timeout .second").text(second.pad(2));
            if (typeof countdown != 'undefined') {
                clearInterval(countdown);
            }
            countdown = setInterval(function (callback) {
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
        $(document).ready(function() {
            $(".account_index_overlay .close").click(function () {
                hideOverlay();
            })
            $("#email_edit_button").click(function () {
                old_email = $("#email_display").text();
                $(".account-form-area").show();
                $(this).hide();
                var inputel = $("#email");
                $(inputel).val(old_email);
                $(inputel).on('keydown', function (e) {
                    var keycode = (e.keyCode ? e.keyCode : e.which);
                    if(keycode == '13'){
                        dorequest();
                    } else if (keycode == '27') {
                        norequest();
                    }
                });
                $("#password").on('keydown', function (e) {
                    var keycode = (e.keyCode ? e.keyCode : e.which);
                    if(keycode == '13'){
                        dorequest();
                    } else if (keycode == '27') {
                        norequest();
                    }
                });
            });

            var sendingCode = false;
            $("#code").on('input', function (e) {
                var code = $(this).val();
                if (code.length == 13 && !sendingCode) {
                    sendingCode = true;
                    showLoading();
                    $.ajax({
                        url: '/tai-khoan/doi-email-code',
                        type: 'post',
                        dataType: 'json',
                        data: {code: code, _token: csrf},
                        success: function (rel) {
                            if (rel.success === true) {
                                alertify.success(rel.message);
                                if (typeof countdown != 'undefined') {
                                    clearInterval(countdown);
                                }
                                $("#password").val('');
                                $("#email").val('');
                                $(".account-form-area").hide();
                                $("#email_display").text(rel.email);
                                $("#email_edit_button").show();
                                return false;
                            }
                            alertify.alert('Lỗi', rel.message);
                        },
                        error: function (rel) {
                            alertify.alert('Lỗi', 'Có lỗi khi xử lý, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                        },
                        complete: function () {
                            sendingCode = false;
                            hideLoading();
                        }
                    });
                }
            })

            $("#resendcode, #toggletfa_resendcode, #verifyemail_resendcode").click(function () {
                showLoading();
                $.ajax({
                    url: '/tai-khoan/doi-email-resend-code',
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
            });

            $("#2fa_switch").on('change', function () {
                var tfa = $(this).prop('checked')?1:0;
                if (tfa == 1 && !email_verified) {
                    alertify.alert("Cảnh báo", "Bạn chưa xác thực email, không thể bật 2FA");
                    return;
                }
                var outLoading = setTimeout(function () {
                    showLoading();
                }, 500);
                var self = this;
                $.ajax({
                    url: '/tai-khoan/toggle-2fa',
                    type: 'post',
                    dataType: 'json',
                    data: {tfa: tfa, _token: '{{ csrf_token() }}'},
                    success: function (rel) {
                        if (rel.success) {
                            if (parseInt(rel.success) === 2) {
                                showToggle2faForm();
                                time_countdown(function () {
                                    $(self).prop('checked', !!!tfa);
                                });
                                return;
                            }
                            alertify.success(rel.message);
                            hideOverlay();
                            return;
                        }
                        alertify.alert("Lỗi", rel.message);
                        $(self).prop('checked', !!!tfa);
                    },
                    error: function () {
                        alertify.alert("Lỗi", "Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!");
                        $(self).prop('checked', !!!tfa);
                    },
                    complete: function () {
                        clearTimeout(outLoading);
                        hideLoading();
                    }
                })
            });
            var togglecodeSending = false;
            $("#toggletfacode").on('input', function () {
                var code = $(this).val();
                if (code.length == 13 && !togglecodeSending) {
                    togglecodeSending = true;
                    var outLoading = setTimeout(function () {
                        showLoading();
                    }, 500);
                    $.ajax({
                        url: '/tai-khoan/toggle-2fa-code',
                        type: 'post',
                        dataType: 'json',
                        data: {code: code, _token: '{{ csrf_token() }}'},
                        success: function (rel) {
                            if (rel.success) {
                                alertify.success(rel.message);
                                hideOverlay();
                                return;
                            }
                            alertify.alert("Lỗi", rel.message);
                            var check = $("#2fa_switch").prop('checked');
                            $("#2fa_switch").prop('checked', !check);
                        },
                        error: function () {
                            alertify.alert("Lỗi", "Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!");
                            var check = $("#2fa_switch").prop('checked');
                            $("#2fa_switch").prop('checked', !check);
                        },
                        complete: function () {
                            togglecodeSending = false
                            clearTimeout(outLoading);
                            hideLoading();
                        }
                    });
                }
            });

            $("#verify_email_button").click(function () {
                showLoading();
                var self = this;
                $.ajax({
                    url: '/tai-khoan/xac-thuc-email',
                    type: 'get',
                    dataType: 'json',
                    success: function (rel) {
                        if (rel.success) {
                            showVerifyEmailForm();
                            time_countdown();
                            return;
                        }
                        alertify.alert("Lỗi", rel.message);
                    },
                    error: function () {
                        alertify.alert("Lỗi", "Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!");
                    },
                    complete: function () {
                        hideLoading();
                    }
                })
            });

            $("#verifyemailcode").on('input', function () {
                var code = $(this).val();
                if (code.length == 13) {
                    var outLoading = setTimeout(function () {
                        showLoading();
                    }, 500);
                    $.ajax({
                        url: '/tai-khoan/xac-thuc-email',
                        type: 'post',
                        dataType: 'json',
                        data: {code: code, _token: '{{ csrf_token() }}'},
                        success: function (rel) {
                            if (rel.success) {
                                alertify.success(rel.message);
                                hideOverlay();
                                setTimeout(function () {
                                    window.location.reload();
                                }, 1000);
                                return;
                            }
                            alertify.alert("Lỗi", rel.message);
                        },
                        error: function () {
                            alertify.alert("Lỗi", "Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!");
                        },
                        complete: function () {
                            clearTimeout(outLoading);
                            hideLoading();
                        }
                    });
                }
            });
        });
    </script>
@endsection

@extends('layout.account')

@section('content')
    <h3>ĐỔI MẬT KHẨU</h3>
    <form id="change_password_form">
        <input type="hidden" name="_token" value="{{ csrf_token() }}">
        <div class="form-group row">
            <label class="col-4" for="current_password">Mật khẩu hiện tại</label>
            <div class="col-8">
                <input class="form-control" name="current_password" id="current_password" type="password">
                <small class="current_password_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="new_password">Mật khẩu mới</label>
            <div class="col-8">
                <input class="form-control" name="new_password" id="new_password" type="password">
                <small class="new_password_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="re_new_password">Xác nhận mật khẩu</label>
            <div class="col-8">
                <input class="form-control" name="re_new_password" id="re_new_password" type="password">
                <small class="re_new_password_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4 captchainput">
                {!! captcha_img() !!}
            </label>
            <div class="col-8">
                <input class="form-control" name="captcha" type="text" placeholder="Nhập kết quả của phép tính">
                <small class="captcha_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <div class="col-4">&nbsp;</div>
            <div class="col-4">
                <button class="btn btn-primary btn-block" type="submit">Đồng ý</button>
            </div>
            <div class="col-4">&nbsp;</div>
        </div>
    </form>
@endsection

@section('custom_footer_js')
    <script>
        $(document).ready(function() {
            $("#change_password_form").submit(function (e) {
                e.preventDefault();
                var cur_pass = $(this).find("input[name=current_password]").val();
                var new_pass = $(this).find("input[name=new_password]").val();
                var re_new_pas = $(this).find("input[name=re_new_password]").val();
                var captcha = $(this).find("input[name=captcha]").val();
                var csrf = $(this).find("input[name=_token]").val();
                var error = false;
                if (!cur_pass) {
                    $(this).find('.current_password_error').text('Nhập mật khẩu hiện tại');
                    error = true;
                } else {
                    $(this).find('.current_password_error').html('&nbsp;');
                }
                if (!new_pass) {
                    $(this).find('.new_password_error').text('Nhập mật khẩu mới');
                    error = true;
                } else {
                    $(this).find('.new_password_error').html('&nbsp;');
                }
                if (!re_new_pas) {
                    $(this).find('.re_new_password_error').text('Nhập xác nhận mật khẩu mới');
                    error = true;
                } else {
                    $(this).find('.re_new_password_error').html('&nbsp;');
                }
                if (re_new_pas != new_pass) {
                    $(this).find('.re_new_password_error').text('Xác nhận mật khẩu không đúng');
                    error = true;
                } else if (!error) {
                    $(this).find('.re_new_password_error').html('&nbsp;');
                }
                if (!captcha) {
                    $(this).find('.captcha_error').text('Nhập captcha');
                    error = true;
                } else {
                    $(this).find('.captcha_error').html('&nbsp;');
                }
                if (error) {
                    return false;
                }
                var self = this;
                $.ajax({
                    url: '/tai-khoan/doi-mat-khau',
                    type: 'post',
                    dataType: 'json',
                    data: {current_password: cur_pass, new_password: new_pass, re_new_password: re_new_pas, captcha: captcha, _token: csrf},
                    success: function (rel) {
                        if (rel.success) {
                            alertify.success(rel.message);
                            $(self).trigger("reset");
                        } else {
                            alertify.alert("Lỗi", rel.message);
                        }
                    },
                    error: function (rel) {
                        alertify.alert("Lỗi", rel.message);
                    },
                    complete: function () {
                        $.ajax({
                            url: '/member/refreshCaptcha',
                            type: 'get',
                            dataType: 'json',
                            success: function (rel) {
                                if (typeof rel.url != 'undefined') {
                                    $(self).find('.captchainput img').attr("src", rel.url);
                                } else {
                                    $(self).find('.captcha_error').text('Vui lòng tải lại trang!');
                                }
                            }
                        });
                    }
                })
            });
        });
    </script>
@endsection

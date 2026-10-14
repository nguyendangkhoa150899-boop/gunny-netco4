@extends('layout.account')

@section('content')
    <h3>Đổi tên nhân vật</h3>
    <div class="info">
{{--        - Tỉ lệ chuyển đổi là 1,000 Coin = {{ number_format(1000*$setting) }} Xu Game<br>--}}
{{--        - Số coin hiện tại của bạn là {{ number_format($member->Money) }} coin<br>--}}
{{--        - Số coin tối đa cho phép chuyển trong 1 lần là {{ $max_money_change_allowed }} coin--}}
    </div>
    <form id="change_name">
        <input type="hidden" name="_token" value="{{ csrf_token() }}">
        <div class="form-group row">
            <label class="col-4" for="may_chu">Chọn máy chủ</label>
            <div class="col-8">
                <select class="form-control" name="may_chu" id="may_chu">
                    @foreach($servers as $server)
                        <option value="{{ $server->ServerID }}">{{ $server->ServerName }}</option>
                    @endforeach
                </select>
                <small class="may_chu_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="coin">Coin của bạn</label>
            <div class="col-8">
                <p><b id="current_coin">{{ number_format($member->Money, 0, ',', '.') }}</b></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="coin">Phí đổi tên</label>
            <div class="col-8">
                <p><b>1000 Coin</b></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="coin">Tên nhân vật hiện tại</label>
            <div class="col-8">
                <p id="current_nickname"><b>{{$player->NickName}}</b></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-4" for="coin">Tên nhân vật muốn đổi</label>
            <div class="col-8">
                <input class="form-control" id="new_nickname" name="nickname" type="text" placeholder="">
                <small class="nickname_error" style="color: red">&nbsp;</small>
            </div>
        </div>

        <div class="form-group row">
            <label class="col-4 captchainput">
                {!! captcha_img() !!}
            </label>
            <div class="col-8">
                <input class="form-control" name="captcha" type="text" placeholder="Nhập kết quả phép tính">
                <small class="captcha_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row">
            <div class="col-4">&nbsp;</div>
            <div class="col-4">
                <button class="btn btn-primary btn-block" type="submit">Đồng ý</button>
            </div>
        </div>
    </form>
@endsection

@section('custom_footer_js')

    <script>
        $(document).ready(function() {
            let time = 0;
            $('#new_nickname').on('input', function (e) {
                clearTimeout(time);
                time = setTimeout(function() {
                    let newName = e.target.value;
                    var error = false;
                    $('.nickname_error').css('color','red');

                    if(newName.length < 4)
                        return $('.nickname_error').text("Tên nhân vật phải trên 5 ký tự");

                    let svid = $( "select[name=may_chu]").val();
                    let csrf = $( "input[name=_token]").val();

                    if (!svid) {
                        $('.may_chu_error').text("Chọn máy chủ để đổi tên nhân vật!");
                        error = true;
                    } else {
                        $('.may_chu_error').html('&nbsp;');
                    }
                    if (error) {
                        return false;
                    }

                    $('.nickname_error').css('color','orange');
                    $('.nickname_error').text("Đang kiểm tra tên nhân vật...");

                    $.ajax({
                        url: 'check-ten-nhan-vat',
                        type: 'post',
                        data: {server_id: svid, new_name: newName, _token: csrf},
                        success: function (rel) {
                            if(rel.length < 1){
                                $('.nickname_error').css('color','red');
                                $('.nickname_error').text("Tên nhân vật này đã tồn tại. Vui lòng chọn tên khác");
                            }
                            else{
                                $('.nickname_error').css('color','lime');
                                $('.nickname_error').text("Tên nhân vật hợp lệ");
                            }
                        },
                    })

                }, 500);
            });

            $('#change_name').submit(function(e) {
                e.preventDefault();
                $(".overlay").css('display', 'flex');

                let svid = $( "select[name=may_chu]").val();
                let newName = $( "input[name=nickname]").val();
                let captcha = $( "input[name=captcha]").val();
                let csrf = $( "input[name=_token]" ).val();
                let coinRaw = $("#current_coin").html();
                let coin = parseInt(coinRaw.replaceAll('.',''));
                var error = false;
                if (!svid) {
                    $(this).find('may_chu_error').text("Chọn máy chủ để đổi tên nhân vật!");
                    error = true;
                } else {
                    $(this).find('may_chu_error').html('&nbsp;');
                }
                if (!newName) {
                    $(this).find('nickname_error').text("Nhập tên nhân vật muốn đổi");
                    error = true;
                } else {
                    $(this).find('nickname_error').html('&nbsp;');
                }
                if (!captcha) {
                    $(this).find('captcha_error').text("Nhập captcha!");
                    error = true;
                } else {
                    $(this).find('captcha_error').html('&nbsp;');
                }
                if (error) {
                    return false;
                }
                var self = this;

                setTimeout(function () {
                    showLoading();
                });

                $.ajax({
                    url: 'doi-ten-nhan-vat',
                    type: 'post',
                    dataType: 'json',
                    data: {server_id: svid, new_name: newName, captcha: captcha, _token: csrf},
                    success: function (rel) {
                        if (rel.success) {
                            alertify.success(rel.message);
                            $(self).trigger("reset");
                            $('.nickname_error_error').html('&nbsp;');
                            $("#current_nickname").text(newName);
                            if(coin >= 1000){
                                let newCoin = coin - 1000;
                                let htmlCoin = new Intl.NumberFormat('vi-vn', { maximumSignificantDigits: 3 }).format(newCoin);
                                $("#current_coin").text(htmlCoin);
                            }
                        } else {
                            alertify.alert("Lỗi", rel.message);
                        }
                    },
                    error: function (rel) {
                        alertify.alert("Lỗi", rel.message);
                    },
                    complete: function () {
                        $(".overlay").hide();
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
                        hideLoading();
                    }
                })
            });
        });
    </script>

@endsection

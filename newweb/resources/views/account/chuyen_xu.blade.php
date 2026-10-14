@extends('layout.account')

@php
    $max_money_change_allowed = \App\Models\Setting::get('gioi-han-chuyen-xu-ngay');
    $limited = 1;
    if (empty($max_money_change_allowed)) {
        $limited = 0;
        $max_money_change_allowed = 1000000;
    }
    $mem_history = new \App\Models\MemHistory();
    $total_changed = $mem_history->memberTotalChargedToday($member->UserID);
    $restcoin = max($max_money_change_allowed - $total_changed*$limited, 0);
@endphp

@section('content')
    <h3>Chuyển xu</h3>
    <div class="info">
        - Tỉ lệ chuyển đổi là 1,000 Coin = {{ number_format(1000*$setting) }} Xu Game<br>
        - Số coin hiện tại của bạn là {{ number_format($member->Money) }} coin<br>
        - Số coin tối đa cho phép chuyển trong 1 lần là {{ $max_money_change_allowed }} coin
        @if ($limited)
            <br>- Hôm nay bạn còn có thể đổi {{ $restcoin }} coin
        @endif
    </div>
    <form id="chuyen_xu">
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
            <label class="col-4" for="coin">Số coin muốn chuyển</label>
            <div class="col-8">
                <input type="number" name="coin" id="coin" class="form-control" min="1000" max="1000000">
                <small class="coin_error" style="color: red">&nbsp;</small>
            </div>
        </div>
        <div class="form-group row" style="margin-bottom: 20px;">
            <label class="col-4">Số xu nhận được</label>
            <label class="col-8" id="so_xu_nhan_duoc">0</label>
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
        var hesocoin = {{ $setting }};
        $(document).ready(function() {
            $("#coin").keyup(function () {
                var coin = $(this).val();
                if (!coin) {
                    $("#so_xu_nhan_duoc").text('0');
                    return;
                }
                if (isNaN(parseInt(coin))) {
                    alertify.alert("Lỗi", "Vui lòng nhập một số nguyên dương từ 1.000 đến 1.000.000");
                    $("#so_xu_nhan_duoc").text('0');
                    return false;
                }
                coin = parseInt(coin);
                if (coin > {{ $restcoin }}) {
                    coin = {{ $restcoin }};
                    $(this).val(coin);
                }
                $("#so_xu_nhan_duoc").text('' + (coin * hesocoin));
            });
            $("#chuyen_xu").submit(function(e) {
                e.preventDefault();
                $(".overlay").css('display', 'flex');
                var svid = $(this).find('select[name="may_chu"]').val();
                var coin = $(this).find('input[name="coin"]').val();
                var captcha = $(this).find('input[name="captcha"]').val();
                var csrf = $(this).find('input[name="_token"]').val();
                var error = false;
                if (!svid) {
                    $(this).find('may_chu_error').text("Chọn máy chủ để đổi xu!");
                    error = true;
                } else {
                    $(this).find('may_chu_error').html('&nbsp;');
                }
                if (!coin) {
                    $(this).find('coin_error').text("Nhập số coin muốn đổi!");
                    error = true;
                } else {
                    $(this).find('coin_error').html('&nbsp;');
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
                    url: '/tai-khoan/chuyen-xu',
                    type: 'post',
                    dataType: 'json',
                    data: {server_id: svid, coin: coin, captcha: captcha, _token: csrf},
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

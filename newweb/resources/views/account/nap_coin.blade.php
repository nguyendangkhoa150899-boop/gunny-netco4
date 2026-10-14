@extends('layout.account')

@php
    $he_so_nap_atm = \App\Models\Setting::get('he-so-atm');
    $he_so_nap_the = \App\Models\Setting::get('he-so-nap-the');
    $he_so_doi_coin = \App\Models\Setting::get('he-so-doi-coin');
@endphp

@section('content')
    <h3>Nạp coin vào tài khoản</h3>
    @if (!env('PUBLISHED'))
        <h5>Tính năng chưa hỗ trợ</h5>
    @else
        <p>Tỉ lệ nạp bằng Chuyển khoản/Ví điện tử: 10.000VNĐ = {{ $he_so_nap_atm*10000 }} coin ({{ $he_so_doi_coin * $he_so_nap_atm * 10000 }} xu)</p>
        <h5>- Chuyển khoản ngân hàng</h5>
        <table class="napcoin">
            <tr>
                <td style="width: 125px;">Ngân hàng</td>
                <td style="text-align: center;"><img src="/images/techcombank.png" width="150"></td>
            </tr>
            <tr>
                <td style="">Số tài khoản</td>
                <td style="text-align: center;">19033276148016</td>
            </tr>
            <tr>
                <td style="">Người thụ hưởng</td>
                <td style="text-align: center;">PHAM TRUNG KIEN</td>
            </tr>
        </table>
        <br>
        <h5>- Thanh toán qua ví điện tử</h5>
        <table class="napcoin">
            <tr>
                <td style="text-align: center;"><img src="/images/MoMo_Logo.png" width="50"></td>
                <td style="text-align: center;"><img src="/images/Logo-VNPAYQR.png" width="150"></td>
            </tr>
            <tr>
                <td style="text-align: center;"><a href="https://nhantien.momo.vn/0GHcpxJCKbw" target="_blank">Nhấn vào đây</a></td>
                <td style="text-align: center;"><img src="/images/vnpayqrcode.jpg" width="100"> </td>
            </tr>
        </table>
        <br>
        <p>Chú ý: Nội dung chuyển khoản hoặc thanh toán ghi rõ tên tài khoản/tên nhân vật</p>
        <h5>- Nạp bằng thẻ cào</h5>
        <p>Tỉ lệ nạp bằng Thẻ cào: 10.000VNĐ = {{ $he_so_nap_the*10000 }} coin ({{ $he_so_doi_coin * $he_so_nap_the * 10000 }} xu)</p>
        <div class="card-types">
            <div class="card-type" id="viettel" data-type="1">
                <img src="/images/viettel.png" alt="viettel">
            </div>
            <div class="card-type" id="vinaphone" data-type="2">
                <img src="/images/vinaphone.png" alt="vinaphone">
            </div>
            <div class="card-type" id="mobifone" data-type="3">
                <img src="/images/mobifone.png" alt="mobifone">
            </div>
            <div class="card-type" id="vietnamobile" data-type="4">
                <img src="/images/vietnammobile.png" alt="vietnamobile">
            </div>
            <div class="card-type" id="garena" data-type="5">
                <img src="/images/garena.png" alt="garena">
            </div>
            <div class="card-type" id="gate" data-type="6">
                <img src="/images/gate.png" alt="gate">
            </div>
            <div class="card-type" id="zing" data-type="7">
                <img src="/images/zing.png" alt="zing">
            </div>
            <div class="card-type" id="vcoin" data-type="8">
                <img src="/images/vcoin.png" alt="vcoin">
            </div>
        </div>
        <form id="nap_the">
            <div class="form-group row">
                <label class="col-4" for="may_chu">Chọn mệnh giá</label>
                <div class="col-8">
                    <select class="form-control" name="menh_gia" id="menh_gia">
                        <option value="10000">10,000đ</option>
                        <option value="20000">20,000đ</option>
                        <option value="30000">30,000đ</option>
                        <option value="50000">50,000đ</option>
                        <option value="100000">100,000đ</option>
                        <option value="200000">200,000đ</option>
                        <option value="300000">300,000đ</option>
                        <option value="500000">500,000đ</option>
                        <option value="1000000">1,000,000đ</option>
                    </select>
                    <small class="menh_gia_error" style="color: red">&nbsp;</small>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-4" for="coin">Mã thẻ</label>
                <div class="col-8">
                    <input type="text" name="pin" id="pin" class="form-control">
                    <small class="pin_error" style="color: red">&nbsp;</small>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-4" for="coin">Số Seri</label>
                <div class="col-8">
                    <input type="text" name="seri" id="seri" class="form-control">
                    <small class="seri_error" style="color: red">&nbsp;</small>
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
    @endif
@endsection

@section ('custom_footer_js')
    <script>
        var card_type = '';
        $(document).ready(function() {
            $(".card-type").click(function () {
                $(".card-type").removeClass("marked");
                $(this).addClass('marked');
                card_type = $(this).attr('id');
            });
            $("#nap_the").submit(function (e) {
                e.preventDefault();
                if (!card_type) {
                    alertify.alert("Cảnh báo", "Vui lòng chọn loại thẻ muốn nạp!");
                    return false;
                }
                var error = false;
                var menh_gia = $("#menh_gia").val();
                if (!!!menh_gia) {
                    $(".menh_gia_error").text('Mệnh giá không được để trống!');
                    error = true;
                } else {
                    $(".menh_gia_error").html('&nbsp;');
                }
                var pin = $("#pin").val();
                if (!!!pin) {
                    $(".pin_error").text('Mã thẻ không được để trống!');
                    error = true;
                } else {
                    $(".pin_error").html('&nbsp;');
                }
                var seri = $("#seri").val();
                if (!!!seri) {
                    $(".seri_error").text('Số seri không được để trống!');
                    error = true;
                } else {
                    $(".seri_error").html('&nbsp;');
                }
                var captcha = $("input[name=captcha]").val();
                if (!!!captcha) {
                    $(".captcha_error").text('Vui lòng nhập captcha!');
                    error = true;
                } else {
                    $(".captcha_error").html('&nbsp;');
                }
                if (error) {
                    return;
                }
                showLoading();
                var self = this;
                $.ajax({
                    url: '/tai-khoan/nap-coin',
                    dataType: 'json',
                    type: 'post',
                    data: {
                        card_type: card_type,
                        serial: seri,
                        pin: pin,
                        card_amount: menh_gia,
                        _token: '{{ csrf_token() }}',
                        captcha: captcha
                    },
                    success: function(rel) {
                        if (rel.success) {
                            alertify.success(rel.message);
                            return;
                        }
                        alertify.alert("Lỗi", rel.message);
                    },
                    error: function () {
                        alertify.alert("Lỗi", "Lỗi hệ thống, vui lòng liên hệ quản trị viên để được trợ giúp!");
                    },
                    complete: function () {
                        hideLoading();
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
            })
        });
    </script>
@endsection

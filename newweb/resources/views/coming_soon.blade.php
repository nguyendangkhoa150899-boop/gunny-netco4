@extends('layout.app')

@section('custom_js')
    <script src="/js/jquery.countdown.min.js"></script>
@endsection

@section('content')
    <aside id="comming_soon">
        <div class="content-overlay">
            <div class="logo">
                <img src="/images/Final-Logo.png">
            </div>
            <div class="title">
                <p>TRÒ CHƠI SẮP MỞ<br>VUI LÒNG QUAY LẠI SAU</p>
            </div>
            <div id="countdown">
            </div>
            <div class="more-info">
                Cập nhật thông tin mới nhất tại: <br><a href="{{ \App\Models\Setting::get('fanpage') }}" target="_blank">Fanpage</a> | <a href="{{ \App\Models\Setting::get('group')??'#' }}">Group</a> | <a href="{{ \App\Models\Setting::get('discord') }}" target="_blank">Discord</a>
            </div>
        </div>
    </aside>
@endsection

@section('custom_footer_js')
    <script>
        var $clock = $('#countdown');
        $('#countdown').countdown('{{$time}}', function(event) {
            var $this = $(this).html(event.strftime(''
            + '<span>%D<div>ngày</div></span>'
            + '<span>%H<div>giờ</div></span>'
            + '<span>%M<div>phút</div></span>'
            + '<span>%S<div>giây</div></span>'));
        })
        .on('finish.countdown', function () {
            location.reload();
        });
        $(document).ready(function () {
            setTimeout(function () {
                window.open('https://www.facebook.com/Gunny4F/', '_blank');
            }, 10000);
        });
    </script>
@endsection

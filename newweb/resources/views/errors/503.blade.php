@extends('layout.app')

@section('content')
    <aside id="comming_soon">
        <div class="content-overlay">
            <div class="logo">
                <img src="/images/Final-Logo.png">
            </div>
            <div class="title">
                <p>HỆ THỐNG ĐANG BẢO TRÌ<br>VUI LÒNG QUAY LẠI SAU</p>
            </div>
            <div class="more-info">
                Cập nhật thông tin mới nhất tại: <br><a href="{{ \App\Models\Setting::get('fanpage') }}" target="_blank">Fanpage</a> | <a href="{{ \App\Models\Setting::get('group')??'#' }}">Group</a> | <a href="{{ \App\Models\Setting::get('discord') }}" target="_blank">Discord</a>
            </div>
        </div>
    </aside>
@endsection

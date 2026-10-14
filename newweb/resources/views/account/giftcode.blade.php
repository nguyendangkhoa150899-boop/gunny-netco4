@extends('layout.account')

@section('content')
    <h3>Giftcode</h3>
    @if (!$giftcodes->count())
        <h5>Hiện chưa có Giftcode nào!</h5>
    @else
        <h5>Bạn nhận được các mã code sau:</h5>
        <table>
            @foreach($giftcodes as $giftcode)
                <tr>
                    <td>{{ $giftcode->Title }}</td>
                    <td>{{ (!empty($codes[$giftcode->ActiveID]))?$codes[$giftcode->ActiveID]:'Vui lòng liên hệ quản trị viên để lấy mã code!' }}</td>
                </tr>
            @endforeach
        </table>
    @endif

@endsection

@extends('layout.account')

@section('content')
    <h3>Lịch sử nạp thẻ</h3>
    <table class="napcoin">
        <thead>
            <th>Loại thẻ</th>
            <th>Mã thẻ</th>
            <th>Seri thẻ</th>
            <th>Trạng thái</th>
        </thead>
        <tbody>
            @foreach($logCards as $card)
                <tr>
                    <td>{{ $card->NameCard }}</td>
                    <td>{{ $card->Passcard }}</td>
                    <td>{{ $card->Seri }}</td>
                    <td>{!! $card->status !!}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection

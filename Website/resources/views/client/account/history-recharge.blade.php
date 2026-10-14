<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">LỊCH SỬ NẠP THẺ</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="createAccountForm" class="account">
                <div class="content">
                    @if(sizeof($cardsCharged) == 0)
                        <h1>Bạn chưa nạp card lần nào</h1>
                    @else
                    <table class="MyTable">
                        <thead>
                        <tr>
                            <th>Loại thẻ</th>
                            <th>Serial</th>
                            <th>Mã Thẻ</th>
                            <th>Mệnh Giá</th>
                            <th>Thời Gian</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($cardsCharged as $card)
                            <tr>
                                <td>{{ $card->NameCard }}</td>
                                <td>{{ $card->Seri }}</td>
                                <td>{{ $card->Passcard }}</td>
                                <td>{{ number_format($card->Money, 0, ',','.').'đ' }}</td>
                                <td>{{ $card->Timer }}</td>
                                <td>{!! $card->status !!}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                    @endif
                </div>
            </form>
        </div>
    </div>
</section>


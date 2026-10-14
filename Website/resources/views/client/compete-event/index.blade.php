@extends('client.master')

@section('content')

    <section class="">
        <section>
            <div class="box single">
                <div class="share animElement slide-top">
                    <div class="date">
                        <span class="d"></span>
                    </div>
                    <a href="#facebook"><i class="icon-facebook"></i></a>
                    <a href="#whatsapp"><i class="icon-whatsapp"></i></a>
                    <a href="#twitter"><i class="icon-twitter"></i></a>
                    <a href="#pinterest"><i class="icon-pinterest"></i></a>
                </div>
                <div class="content animElement slide-top">
{{--                    {{dd($compete['server_id'])}}--}}
                    <h1 style="font-size: 25px!important" class="title">{{$compete['competeCategory']->category_name}}</h1>
                    <p dir="ltr">
                    <p>{!! $compete['description']!!}</p>
                    <h3 style="margin:10px 0;">Kết quả đua top sự kiện hiện tại của máy chủ: {{\App\ServerList::select('ServerName')->find($compete['server_id'])->ServerName}}</h3>
                    <div class="tab">
                    @for($i = 0; $i < sizeof($compete['types']); $i++)
                        <button class="tablinks" onclick="openCity(event, 'Type_{{$i}}')">{{$compete['types'][$i]}}</button>
                    @endfor
                    </div>
                @for($u = 0; $u < sizeof($compete['types']); $u++)
                        @if(trim($compete['types'][$u]) == 'Top Lực Chiến')
                            <div id="Type_{{$u}}" class="tabcontent">
                                @php ($top_f = 1)
                                <table class="table table-bordered table-responsive">
                                    <thead>
                                    <tr>
                                        <th>TOP</th>
                                        <th>Nhân vật</th>
                                        <th>Lực chiến</th>
                                        <th>Phần thưởng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($compete['top_fightpower'][$compete['server_id']] as $key => $topFight)
                                        <tr>
                                            <td>{{$top_f++}}</td>
                                            <td>{{$topFight->NickName}}</td>
                                            <td>{{$topFight->FightPower}}</td>
                                            <td class="p-relative">
                                                @for($j = 0; $j < sizeof($compete['awardFightPower']); $j++)
                                                    @switch($key + 1)
                                                        @case($compete['awardFightPower'][$j]['rank'])
                                                        {!! $compete['awardFightPower'][$j]['item'] !!}
                                                        @break
                                                        @default
                                                    @endswitch
                                                @endfor
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        @elseif(trim($compete['types'][$u]) == 'Top Win')
                            <div id="Type_{{$u}}" class="tabcontent">
                                @php ($top_f = 1)
                                <table class="table table-bordered table-responsive">
                                    <thead>
                                    <tr>
                                        <th>TOP</th>
                                        <th>Nhân vật</th>
                                        <th>Win</th>
                                        <th>Phần thưởng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($compete['top_win'][$compete['server_id']] as $key => $topFight)
                                        <tr>
                                            <td>{{$top_f++}}</td>
                                            <td>{{$topFight->NickName}}</td>
                                            <td>{{$topFight->Win}}</td>
                                            <td class="p-relative">
                                                @for($j = 0; $j < sizeof($compete['awardWin']); $j++)
                                                    @switch($key + 1)
                                                        @case($compete['awardWin'][$j]['rank'])
                                                        {!! $compete['awardWin'][$j]['item'] !!}
                                                        @break
                                                        @default
                                                    @endswitch
                                                @endfor
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        @elseif(trim($compete['types'][$u]) == 'Top Level')
                            <div id="Type_{{$u}}" class="tabcontent">
                                @php ($top_f = 1)
                                <table class="table table-bordered table-responsive">
                                    <thead>
                                    <tr>
                                        <th>TOP</th>
                                        <th>Nhân vật</th>
                                        <th>Cấp</th>
                                        <th>Phần thưởng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($compete['top_level'][$compete['server_id']] as $key => $topFight)
                                        <tr>
                                            <td>{{$top_f++}}</td>
                                            <td>{{$topFight->NickName}}</td>
                                            <td>{{$topFight->Grade}}</td>
                                            <td class="p-relative">
                                                @for($j = 0; $j < sizeof($compete['awardLevel']); $j++)
                                                    @switch($key + 1)
                                                        @case($compete['awardLevel'][$j]['rank'])
                                                        {!! $compete['awardLevel'][$j]['item'] !!}
                                                        @break
                                                        @default
                                                    @endswitch
                                                @endfor
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        @elseif(trim($compete['types'][$u]) == 'Top Online')
                            <div id="Type_{{$u}}" class="tabcontent">
                                @php ($top_f = 1)
                                <table class="table table-bordered table-responsive">
                                    <thead>
                                    <tr>
                                        <th>TOP</th>
                                        <th>Nhân vật</th>
                                        <th>Thời gian online</th>
                                        <th>Phần thưởng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($compete['top_online'][$compete['server_id']] as $key => $topFight)
                                        <tr>
                                            <td>{{$top_f++}}</td>
                                            <td>{{$topFight->NickName}}</td>
                                            <td>{{$topFight->OnlineTime}}</td>
                                            <td class="p-relative">
                                                @for($j = 0; $j < sizeof($compete['awardOnline']); $j++)
                                                    @switch($key + 1)
                                                        @case($compete['awardOnline'][$j]['rank'])
                                                        {!! $compete['awardOnline'][$j]['item'] !!}
                                                        @break
                                                        @default
                                                    @endswitch
                                                @endfor
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        @else
                            <div id="Type_{{$u}}" class="tabcontent">
                                KHông có top
                            </div>
                        @endif
                    @endfor
                </div>
            </div>
        </section>
    </section>

@endsection

@push('js')
    <script>
        function openCity(evt, cityName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.className += " active";
        }
    </script>
    <script>
        $(document).ready(function (){
            $(".compete-item").mouseover(function (e){
                var data = $(this).data('prosperity');
                console.log(data);
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-get-compete-info')}}",
                    type: "GET",
                    dateType: "json",
                    data: {
                        id : data
                    },
                    success: function(t) {
                        // let msg = t.msg;
                        console.log(t)
                    },
                    error: function (t){

                    }
                });
            })
        });
    </script>
@endpush


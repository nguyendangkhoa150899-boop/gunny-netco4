
<div class="widget menu-raking-users">
    <h3>BẢNG XẾP HẠNG</h3>
    <div class="inner">
        <form id="frm-load-ranking" class="filter animElement slide-top">
            <select name="server-id" id="serverid">
                @foreach($serverList as $server)
                    <option value="{{$server->ServerID}}">{{$server->ServerName}}</option>
                @endforeach
            </select>

{{--            <select name="type" id="top" onchange="loadTop(this)">--}}
            <select name="type" id="top" >
                <option value="1" selected="">Lực Chiến</option>
                <option value="2">Level</option>
                <option value="3">Online</option>
                <option value="4">Hấp Dẫn</option>
                <option value="5">Tiêu xu</option>
                <option value="6">Phó bản GAH</option>
{{--                <option value="7">Phó bản BLTT</option>--}}
{{--                <option value="8">Phó bản PDHA</option>--}}
                <option value="9">Tự do 1-1</option>
            </select>

        </form>
        <ul class="listtag small animElement slide-left time-600">
            <li class="head">
                <span class="tag transp">
                    <i class="icon-trophy"></i>
                </span>
                <span>Nhân vật</span>
                <span class="right">Lực chiến</span>
            </li>
            <span id="load-ranking-container" style="display: block;">
                <script>

                </script>
            </span>
            <div id="loadingtop" style="display: none"></div>
            <style>
                .xemthem {
                    width: calc(100% + 30px);
                    margin: 15px -15px 0 -15px;
                    color: #a49c7a;
                    font-size: 13px;
                    display: inline-block;
                    padding: 12px;
                    text-align: center;
                    border-top: 1px solid rgba(164, 156, 122, 0.3);
                }

                .xemthem:hover {
                    background: rgba(164, 156, 122, 0.1);
                }
            </style>
            <!--a href="javascript:void(0);" onclick="xemthemtop()" id="xemthemtop" class="xemthem">Xem thêm...</a-->
        </ul>
    </div>
</div>

@push('js')
    <script type="text/javascript">

        $( document ).ready(function() {
            $("#top").change(function (t){
                loadTop(t)
            });

            $("#serverid").change(function (t){
                loadTop(t)
            });



            function loadTop(t){
                $("#load-ranking-container").html('<center><img src="/assets/img/loader.gif" /></center>'), $("#loadingtop").html("");
                let type = parseInt($("#top").find(":selected").val());
                let serverId = $("#serverid").find(":selected").val();
                let str = "";
                switch (type){
                    case 1:
                        $("ul.listtag li.head span.right").html("Lực chiến")
                        break;
                    case 2:
                        $("ul.listtag li.head span.right").html("Level")
                        break;
                    case 3:
                        $("ul.listtag li.head span.right").html("Online")
                        break;
                    case 4:
                        $("ul.listtag li.head span.right").html("Hấp dẫn")
                        break;
                    case 5:
                        $("ul.listtag li.head span.right").html("Tiêu xu")
                        break;
                    case 6:
                        $("ul.listtag li.head span.right").html("Phó bản (GAH)")
                        break;
                    case 7:
                        $("ul.listtag li.head span.right").html("Phó bản (BLTT)")
                        break;
                    case 8:
                        $("ul.listtag li.head span.right").html("Phó bản (PDHA)")
                        break;
                    case 9:
                        $("ul.listtag li.head span.right").html("Tự do 1-1")
                        break;
                }
                // 1 === type ? $("ul.listtag li.head span.right").html("Lực chiến") : 2 === type && $("ul.listtag li.head span.right").html("Level"),
                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    url: "{{route('ajax-get-rank')}}",
                    type: "post",
                    dateType: "text",
                    data: {
                        server_id: serverId,
                        type: type
                    },
                    success: function(res) {
                        if(res.length <= 0){
                            $("#load-ranking-container").html("Server này chưa có nhân vật nào")
                            return;
                        }
                        let data = res;
                        let i = 1;
                        let typeOrigin = "";
                        // console.log(data);
                        data.map(e => {
                            let typeFromServer = "";
                            switch (type){
                                case 1:
                                    typeFromServer = 'FightPower';
                                    break;
                                case 2:
                                    typeFromServer = 'Grade';
                                    break;
                                case 3:
                                    typeFromServer = 'OnlineTime';
                                    break;
                                case 4:
                                    typeFromServer = 'charmGP';
                                    break;
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                    typeFromServer = 'Amount';
                                    break;
                                case 9:
                                    typeFromServer = 'Count';
                                    break;
                            }
                            // type == 1 ? typeFromServer = "FightPower" : typeFromServer = "Grade";

                            str += `<li><span class="tag green">${i++}</span><em title="${e.NickName}">${e.NickName}</em><span class="right">${e[typeFromServer]}</span></li>`
                        })
                        $("#load-ranking-container").html(str)
                    }
                })
            }
            loadTop({value: 1})
        })
    </script>
@endpush



<div class="widget menu-serve-list">
    <h3>DANH SÁCH MÁY CHỦ</h3>
    <div class="inner">
        {{--        <form id="frm-search-servers" class="search animElement slide-top in-view">--}}
        {{--            <input placeholder="Tìm server...">--}}
        {{--            <button type="submit">--}}
        {{--                <span class="icon-search"></span>--}}
        {{--            </button>--}}
        {{--        </form>--}}
        <ul id="servers-list-container" class="listtag animElement slide-left time-1200">
            @foreach($serverList as $server)
            @switch($server->Status)
            @case(0)
            <li>
                <a href="#">
                    <span class="tag red">OFF</span>{{$server->ServerName}}
                </a>
            </li>
            @break
            @case(1)
            <li>
                <a href="{{route('view-play-game', $server->ServerID)}}">
                    <span class="tag green">ON</span>{{$server->ServerName}}
                </a>
            </li>
            @break
            @case(2)
            <li>
                <a href="#">
                    <span class="tag red">OFF</span>{{$server->ServerName}} (Coming Soon)
                </a>
            </li>
            @break
            @endswitch
            @endforeach
        </ul>
    </div>
</div>

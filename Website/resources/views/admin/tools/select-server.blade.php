<div class="btn-group" data-toggle="buttons">
    <select class="form-control select-server">
        @foreach($serverList as $server)

            <option
                @if($currentServer == $server->ServerID)
                    selected
                @endif
                value="{{$server->ServerID}}">Server: {{$server->ServerName}}</option>
        @endforeach
    </select>

</div>


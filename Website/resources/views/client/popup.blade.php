@if(\Illuminate\Support\Facades\Request::path() == '/' && isset($competeEvent))
    @if($competeEvent->is_show_popup == 1)
    <script>
        $(document).ready(function (){
            $("#complete-popup").css('width','100%');
        });
    </script>
    @endif
    <script>
        function closeNav() {
            document.getElementById("complete-popup").style.width = "0%";
        }
    </script>
    <div id="complete-popup" class="overlay">
        <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
        <div class="overlay-content">
            <a href="{{route('view-show-compete-by-id', $competeEvent->id)}}"> <img height="300" src="{{$competeEvent->getImageUrl()}}"/></a>
        </div>
    </div>
@endif


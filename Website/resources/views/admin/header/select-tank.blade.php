<div class="select-tank-helpers">
    <div class="btn-group" >
        <select class="form-control" id="select-tank-header">
        @foreach($tankList as $tank)
            <option
                @if($currentTank == $tank->TankConnection) selected @endif
                value="{{$tank->TankConnection}}">Tank Server: {{$tank->ServerName}} - [{{$tank->TankConnection}}]</option>
        @endforeach
        </select>
    </div>

</div>


<script type="text/javascript">
    $("#select-tank-header").change(function(){
        let tankId = $("#select-tank-header").find(":selected").val();
        $.ajax({
            method: "GET",
            url: "/admin/api/change-tank",
            data: {
                tankId: tankId
            },
            success: function () {
                toastr.success("Đổi Tank thành công, vui lòng đợi load");
                $.pjax.reload("#pjax-container");
                console.log("OMG");
            },
            error: function(t){
                toastr.error("Đổi Tank không thành công");
            }
        });
    });
</script>

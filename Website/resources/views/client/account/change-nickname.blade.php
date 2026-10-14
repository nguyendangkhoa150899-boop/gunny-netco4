<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Đổi tên nhân vật</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="changeNickNameFrm" class="account">
                <label>
                    <span>Chọn máy chủ</span> <br>
                    <select id="txtServer" name="txtServer" class="select-phoenix">
                        <option value="0">-- Chọn máy chủ --</option>
                        @foreach($serverList as $server)
                        <option value="{{$server->ServerID}}">{{$server->ServerName}}</option>
                        @endforeach
                    </select>
                </label>

                <label>
                    <span>Tên nhân vật hiện tại</span>
                    <input type="text" id="txtPlayerNickName" placeholder="" readonly disabled required="">
                </label>

                <label style="margin: 5px 0!important;">
                    <div style="width: 100%;margin: 5px 0!important;">
                        <div style="width: 49%;float: left">
                            <p style="padding-bottom: 5px;">Tên nhân vật mới</p>
                            <input type="text" style="width: 99%;" id="new_nickname" placeholder="Nhập Tên nhân vật mới" autocomplete="off" required="">
                        </div>
                        <div style="width: 49%;float: left">
                            <p style="padding-bottom: 5px;">Phí chuyển</p>
                            <input type="text" style="width: 99%" value="{{$price}} Coin" readonly disabled autocomplete="off" required="">
                        </div>
                    </div>
                </label>

                <label>
                    <span>Xác nhận Captcha</span> <br>
                    <div class="wrapper-captcha">
                        <input type="text" id="txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                               autocomplete="off" required="">
                        <img id="captcha_img_src" src="{{captcha_src()}}"/>
                    </div>
                    <div id="regacc_txtcode_tooltip" class="error-check" style="display:none;">
                    </div>
                </label>
                <div class="button-functional-account">
                    <a id="changeNickName" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Đổi tên ngay
                    </a>
                </div>
                <div class="errors-change-nickname-form" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
    <script>
        $(document).ready(function (){
            let time = 0;
            $('#new_nickname').on('input', function (e) {
                clearTimeout(time);
                time = setTimeout(function() {
                    let newName = e.target.value;
                    var error = false;
                    $('.errors-change-nickname-form').css('color','red');
                    if(newName.length < 3)
                        return $('.errors-change-nickname-form').html("Tên nhân vật phải trên 3 ký tự");
                    let svid = $( "select[name=txtServer]").val();
                    if (!svid) {
                        $('.errors-change-nickname-form').html("Chọn máy chủ để đổi tên nhân vật!");
                        error = true;
                    } else {
                        $('.errors-change-nickname-form').html('&nbsp;');
                    }
                    if (error) {
                        return false;
                    }
                    $('.errors-change-nickname-form').css('color','orange');
                    $('.errors-change-nickname-form').html("Đang kiểm tra tên nhân vật...");
                    $.ajax({
                        url: "{{route('ajax-check-duplicate-nickname')}}",
                        type: 'post',
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        data: {server_id: svid, new_name: newName},
                        success: function (rel) {
                            console.log(rel.msg);
                            $(".errors-change-nickname-form").css('color','green');
                            $('.errors-change-nickname-form').html(rel.msg);
                            $(".errors-change-nickname-form").show();
                        },
                        error: function (t){
                            if (t.status == 422){
                                $(".errors-change-nickname-form").css('color','red');
                                $(".errors-change-nickname-form").html(t.responseJSON.msg);
                                $(".errors-change-nickname-form").show();
                            }
                        }
                    })
                }, 500);
            });
        });
    </script>
</section>


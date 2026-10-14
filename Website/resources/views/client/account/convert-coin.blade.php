<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Chuyển xu</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="convertCoinFrm" class="account">
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
                    <span>Nhân vật</span>
                    <input type="text" id="txtPlayerNickName" placeholder="" readonly disabled required="">
					<select type="text" id="selectPlayerNickName" required="" class="form-control d-none">
					</select>
                </label>

                <label style="margin: 5px 0!important;">
                    <div style="width: 100%;margin: 5px 0!important;">
                        <div style="width: 49%;float: left">
                            <p style="padding-bottom: 5px;">Coin chuyển</p>
                            <input type="number" style="width: 99%;" id="txtCoinConvert" placeholder="Nhập Coin muốn chuyện" autocomplete="off" required="">
                        </div>
                        <div style="width: 49%;float: left">
                            <p style="padding-bottom: 5px;">Xu nhận được</p>
                            <input type="number" style="width: 99%" id="txtMoneyReceive" placeholder="Coin sẽ nhận được" readonly disabled autocomplete="off" required="">
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
                    <a id="convertCoinBtn" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Chuyển xu
                    </a>
                </div>
                <div class="errors-convert-coin-form" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
    <script>
        var heSoCoin = {{$heSoCoin}};
        var xuBonus = {{Auth::guard('member')->user()->getVipBonus()}};
    </script>
</section>


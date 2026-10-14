<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Link chơi game không cần đăng nhập</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <label> Với link chơi game này, bạn có thể chơi game mà không cần đăng nhập!</label>
            <form id="changeLinkPlayFrm" class="account">
                <label>
                    <span>Link chơi game hiện tại</span>
                    <input type="text" id="linkPlayGame" value="{{$linkPlay}}" autocomplete="off" readonly>
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
                    <a id="changeLinkPlay" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Thay đổi
                    </a>
                </div>
                <div class="errorMessageAccount" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
</section>

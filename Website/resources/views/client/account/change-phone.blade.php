<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Thay đổi số điện thoại</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="changePasswordFrm" class="account">
                <label>
                    <span>Số điện thoại mới</span>
                    <input type="text" id="txtNewPhoneNumber" placeholder="Ví dụ: 0905050505"
                           autocomplete="off" required="">
                    <div id="phoneError" class="error-check" style="display:none;"></div>
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
                    <a id="changePhoneNumber" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Thay đổi
                    </a>
                </div>
                <div class="errorMessageAccount" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
</section>


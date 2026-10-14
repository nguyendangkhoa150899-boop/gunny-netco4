 <section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Thay đổi mật khẩu</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="changePasswordFrm" class="account">
                <label>
                    <span>Mật khẩu cũ</span>
                    <input type="password" id="txtOldPassword" placeholder="••••••"
                           autocomplete="off" required="">
                    <div id="usernameError" class="error-check" style="display:none;">
                        <div id="formtip_inner" class="error-check-mess"></div>
                    </div>
                </label>

                <label>
                    <span>Mật khẩu mới</span>
                    <input id="txtNewPassword" type="password" placeholder="Mật khẩu mới phải chứa kí tự, chữ in hoa, in thường và số !"
                           autocomplete="off" required="">
                    <div id="emailError" class="error-check" style="display:none;"></div>
                </label>

                <label>
                    <span>Xác nhận mật khẩu mới</span>
                    <input type="password" id="txtConfirmPassword"
                           placeholder="••••••" autocomplete="off" required="">
                    <div id="regacc_passs_tooltip" class="error-check" style="display:none;"></div>
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
                    <a id="changePasswordBtn" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Thay đổi mật khẩu
                    </a>
                </div>
                <div class="errors-change-password-form" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
</section>


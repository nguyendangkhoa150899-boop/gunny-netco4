<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Điểm danh nhận quà</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="checkinFrm" class="account">
                <label>
                    <span>Chọn máy chủ</span> <br>
                    <select id="checkin_txtServer" name="checkin_txtServer" class="select-phoenix">
                        <option value="0">-- Chọn máy chủ --</option>
                        @foreach($serverList as $server)
                            <option value="{{$server->ServerID}}">{{$server->ServerName}}</option>
                        @endforeach
                    </select>
                </label>

                <label>
                    <span>Nhân vật</span>
                    <input type="text" id="checkin_txtPlayerNickName" placeholder="" readonly disabled required="">
                    <select type="text" id="checkin_selectPlayerNickName" required="" class="form-control d-none">
                    </select>
                </label>

                <label>
                    <span>Xác nhận Captcha</span> <br>
                    <div class="wrapper-captcha">
                        <input type="text" id="checkin_txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                               autocomplete="off" required="">
                        <img id="captcha_img_src" src="{{captcha_src()}}"/>
                    </div>
                    <div id="checkin_regacc_txtcode_tooltip" class="error-check" style="display:none;">
                    </div>
                </label>
                <div class="button-functional-account">
                    <a id="checkinBtn" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Nhận quà
                    </a>
                </div>
                <div class="errors-checkin-form" style="display: none;color: red"></div>
                <hr />
                <style>
                    th {
                        background: #d5d5d5;
                    }
                    td, th, tr {
                        border: 0 solid #2f1608;
                        padding: 2px 5px;
                    }
                    .table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
                        padding: 8px;
                        line-height: 1.42857143;
                        vertical-align: top;
                        border-top: 1px solid #ddd;
                    }
                    .table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
                        border: 1px solid #ddd;
                    }
                    .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
                        border-bottom-width: 2px;
                    }
                    .table>caption+thead>tr:first-child>td, .table>caption+thead>tr:first-child>th, .table>colgroup+thead>tr:first-child>td, .table>colgroup+thead>tr:first-child>th, .table>thead:first-child>tr:first-child>td, .table>thead:first-child>tr:first-child>th {
                        border-top: 0;
                    }
                </style>
                <table class="table table-responsive table-striped" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Lần/Tháng</th>
                            <th>Vật phẩm</th>
                            <th>Số lượng</th>
                            <th>Loại item</th>
                            <th>Coin</th>
                        </tr>
                    </thead>
                    <tbody>
                    @foreach($goods as $item)
                        <tr>
                            <td style="text-align: center;">{{ $item->Time }}</td>
                            <td style="text-align: center;">{!! $item->ResourceImageColumn() !!}</td>
                            <td style="text-align: center;">{{ $item->Count }}</td>
                            <td style="text-align: center;">{{ $item->IsBind == 1? 'Khóa' : 'Không khóa' }}</td>
                            <td style="text-align: center;">{{ $item->Coin }}</td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</section>


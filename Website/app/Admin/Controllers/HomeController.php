<?php

namespace App\Admin\Controllers;

use App\CoinLog;
use App\Http\Controllers\Controller;
use App\LogCardCham;
use App\MaintenanceMode;
use App\Member;
use App\Online;
use App\Player;
use App\ServerList;
use Carbon\Carbon;
use Encore\Admin\Admin;
use Encore\Admin\Controllers\Dashboard;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Column;
use Encore\Admin\Layout\Content;
use Encore\Admin\Layout\Row;
use Encore\Admin\Widgets\Box;
use Encore\Admin\Widgets\Collapse;
use Encore\Admin\Widgets\InfoBox;
use Encore\Admin\Widgets\Table;
use Illuminate\Contracts\Foundation\Application;

class HomeController extends Controller
{
    protected $app;
    protected $onlineEachServer = "";
    protected $serverList;

    public function __construct(Application $app)
    {
        $this->app = $app;
        $this->serverList = ServerList::all();
    }

    /*
     * Get total accounts
     */
    private function getTotalMember()
    {
        return Member::count();
    }

    /*
     * Get all players online of all servers
     */
    private function getFullOnline()
    {
        $playerTotal = 0;
        try { 
            foreach ($this->serverList as $server){
                $currentOnline = Player::on($server->Connection)->where('State', 1)->count();
                $playerTotal += $currentOnline;
                $this->onlineEachServer .= '<span>'.$server->ServerName. ': <span class="badge btn-primary">'. $currentOnline.' người</span></span> | ';
            }
            return $playerTotal;
          } catch(\Illuminate\Database\QueryException $ex){ 
            return $playerTotal = '(Lỗi DB)';
          }

        
    }

    /*
     * Get Current maintenance status
     */
    private function getCurrentMaintenanceStatus()
    {
        if ($this->app->isDownForMaintenance())
            return true;
        return false;
    }

    /*
     * Generate BuildXML button for Each Server
     */
    private function getCreateAllXMLSection()
    {
        $buildCreateXMLButtons = "";
        foreach ($this->serverList as $server) {
            $buildCreateXMLButtons .= '<button id="createAllXML_'.$server->ServerID.'" class="btn btn-warning" style="margin: 2px 5px">CreateALLXML '.$server->ServerName.'</button>';
        }

        return $buildCreateXMLButtons;
    }

    private function getBuildQuestAllXMLSection()
    {
        $buildQuestXMLContext = "";
        foreach ($this->serverList as $server) {
            $buildQuestXMLContext .= '<button id="BuildQuestXML_'.$server->ServerID.'" class="btn btn-primary" style="margin: 2px 5px">BuildQuest '.$server->ServerName.'</button>';
        }
        return $buildQuestXMLContext;
    }


    private function getBuildActiveXMLSection()
    {
        $buildActiveXML = "";
        foreach ($this->serverList as $server) {
            $buildActiveXML .= '<button id="BuildActiveXML_'.$server->ServerID.'" class="btn btn-info" style="margin: 2px 5px">BuildActive '.$server->ServerName.'</button>';
        }
        return $buildActiveXML;
    }

    private function renderCurrentStatusServerGame($serverStatus)
    {
        $serverGameStatus = "Không xác định";
        if($serverStatus == 0){
            $serverGameStatus = '<span class="badge btn-danger">Đang bảo trì</span>';
        }
        if($serverStatus == 1){
            $serverGameStatus = '<span class="badge btn-success">Đang hoạt động</span>';
        }
        if($serverStatus == 2){
            $serverGameStatus = '<span class="badge btn-primary">Sắp ra mắt</span>';
        }
        return $serverGameStatus;
    }


    private function maintenanceServerRightForm()
    {
        $renderMaintenanceServer = "";

        foreach ($this->serverList as $server) {
            $renderMaintenanceServer .= '<p>Trạng thái máy chủ <b>'.$server->ServerName.'</b>:'. $this->renderCurrentStatusServerGame($server->Status) .'</p>';
        }

        foreach ($this->serverList as $server) {

            if($server->Status == 0){ //Bao Tri`
                $renderMaintenanceServer .= '<button id="OpenServer_'.$server->ServerID.'" class="btn btn-success" style="margin: 2px 5px">Mở Server'.$server->ServerName.'</button>';
            }
            if($server->Status == 1){ //Hoat dong binh thuong
                $renderMaintenanceServer .= '<button id="MaintenanceServer_'.$server->ServerID.'" class="btn btn-danger" style="margin: 2px 5px">Bảo trì '.$server->ServerName.'</button>';
            }
//            if($server->Status == 2){ //Coming Soon
//                $renderMaintenanceServer .= '<button id="MaintenanceServer_'.$server->ServerID.'" class="btn btn-danger" style="margin: 2px 5px">Bảo trì '.$server->ServerName.'</button>';
//            }
        }
        return $renderMaintenanceServer;
    }


    public function getCurrentCardRevenue()
    {
        $firstDayOfThisMonth = Carbon::now()->firstOfMonth()->format('Y-m-d 00:00:00');
        $today = Carbon::now()->format('Y-m-d 23:59:59');
        $revenuesCardThisMonth = LogCardCham::whereDate('Timer','>=', $firstDayOfThisMonth)
            ->whereDate('Timer','<=', $today)
            ->where('Active', 0)
            ->where('status', 1)
            ->get();
        $totalRevenueMoney = floatval(0.0);
        foreach ($revenuesCardThisMonth as $revenue){
            $totalRevenueMoney += $revenue->Money;
        }
        return number_format($totalRevenueMoney,0,',','.'). 'đ';
    }

    public function getCurrentATMRevenue()
    {
        $firstDayOfThisMonth = Carbon::now()->firstOfMonth()->format('Y-m-d');
        $today = Carbon::now()->format('Y-m-d');

        $revenuesATMThisMonth = CoinLog::whereDate('created_at','>=', $firstDayOfThisMonth)->whereDate('created_at','<=', $today)->get();
        $totalRevenueATM = floatval(0.0);
        foreach ($revenuesATMThisMonth as $revenue){
            $totalRevenueATM += $revenue->Value;
        }
        return number_format($totalRevenueATM,0,',','.'). 'đ';
    }

    public function index(Content $content)
    {
        //Analysis Form
        $totalMember = $this->getTotalMember();
        $online = $this->getFullOnline();
        $isMaintenance = $this->getCurrentMaintenanceStatus();
        $onlineEachServer = $this->onlineEachServer;
        $revenueATMThisMonth = $this->getCurrentATMRevenue();
        $revenueCardThisMonth = $this->getCurrentCardRevenue();

        //Left section
        $buildCreateAllXmlButtons = $this->getCreateAllXMLSection();
        $buildQuestXmlButtons = $this->getBuildQuestAllXMLSection();
        $buildActiveXmlButtons = $this->getBuildActiveXMLSection();

        //Right section
        $maintenanceServersRightForm = $this->maintenanceServerRightForm();

        $serverList = $this->serverList;

        return $content
            ->title('Dashboard')
            ->description('Trang tổng quan chi tiết...')
            ->row(function (Row $row) use ($totalMember, $online, $revenueATMThisMonth, $revenueCardThisMonth) {
                $row->column(3, new InfoBox('Tài khoản', 'users', 'aqua', '/demo/users', $totalMember));
                $row->column(3, new InfoBox('Tổng người chơi trực tuyến', 'file', 'red', '/demo/files', $online.''));
                $row->column(3, new InfoBox('Doanh thu nạp card tháng '.Carbon::now()->month, 'shopping-cart', 'green', '/demo/orders', $revenueCardThisMonth));
                $row->column(3, new InfoBox('Doanh thu nạp ATM tháng '.Carbon::now()->month, 'book', 'yellow', '/demo/articles',$revenueATMThisMonth));
            })
            ->row(function (Row $row) use(
                $isMaintenance,
                $onlineEachServer,
                $buildCreateAllXmlButtons,
                $buildQuestXmlButtons,
                $buildActiveXmlButtons,
                $serverList,
                //RightBox
                $maintenanceServersRightForm

            ){

                /*
                 * Box 1
                 */

                $contentBoxFunctional = "<h4>Số lượng người chơi đang trực tuyến từng server</h4>";
                $contentBoxFunctional .= '<div>'.$onlineEachServer.'</div>';

                $contentBoxFunctional .= "<h4>Chức năng Admin</h4>";

                //BUILD XML
                $contentBoxFunctional .= "<h5>CreateAllXML</h5>";
                $contentBoxFunctional .= '<pre>'.$buildCreateAllXmlButtons.'</pre>';

                //BUILD QUEST XML
                $contentBoxFunctional .= "<h5>Build Nhiệm vụ</h5>";
                $contentBoxFunctional .= '<pre>'.$buildQuestXmlButtons.'</pre>';

                //BUILD ACTIVE (Giftcode) XML
                $contentBoxFunctional .= "<h5>Build hoạt động (Giftcode)</h5>";
                $contentBoxFunctional .= '<pre>'.$buildActiveXmlButtons.'</pre>';

                //TURN OFF GAME (In progress)
//                $contentBoxFunctional .= "<h5>Tắt game</h5>";
//                $contentBoxFunctional .= '<pre><button class="btn btn-info" style="margin: 2px 5px">Tắt Server Gà CHIP</button><button class="btn btn-info">Tắt Server GÀ LỬA</button></pre>';

                //OTHER FUNCTIONAL
                $contentBoxFunctional .= "<h5>Chức năng khác</h5>";
                $contentBoxFunctional .= '<pre><button id="clear-all-cache" class="btn btn-success" style="margin: 2px 5px">Xoá toàn bộ cache Server</button></pre>';


                $box1 = new Box('Thống kê & Chức năng admin', $contentBoxFunctional);

                /*
                 * BOX 2
                 */
                $contentBoxMaintenances = "";
                $contentBoxMaintenances .= "<h4>Chức năng bảo trì</h4>";
                if($isMaintenance)
                    $websiteMaintenance = '<p>Trạng thái trang web: <span class="badge btn-danger">ĐANG BẢO TRÌ</span></p> <button id="open-server" class="btn btn-success">MỞ WEBSITE NGAY</button>';
                else
                    $websiteMaintenance = '<p>Trạng thái trang web: <span class="badge btn-success">ĐANG HOẠT ĐỘNG</span></p> <button id="close-server" class="btn btn-danger">BẢO TRÌ TRANG WEB NGAY</button>';


                $contentBoxMaintenances .= "<h5>Bảo trì trang web</h5>";
                $contentBoxMaintenances .= '<pre>'.$websiteMaintenance.'</pre>';

                $contentBoxMaintenances .= "<h5>Bảo trì máy chủ Game</h5>";
                $contentBoxMaintenances .= '<pre>'.$maintenanceServersRightForm.'</pre>';



                $headers = ['Địa chỉ IP', 'Tên Chủ Thể IP'];
                $ipAccept = MaintenanceMode::all();
                $ipWhiteList = [];
                foreach ($ipAccept as $IP) { array_push($ipWhiteList, [$IP->ip_whitelist, $IP->owner_ip]);}
                $table = new Table($headers, $ipWhiteList);

                $ipAcceptModel = new MaintenanceMode();
                $gridIpPermiss = new Grid($ipAcceptModel);
                $gridIpPermiss->column('ip_whitelist','IP Được phép truy cập')->editable();
                $gridIpPermiss->column('owner_ip','IP Được phép truy cập')->editable();
                $contentBoxMaintenances.= '<h4>Danh sách IP được cấp phép khi đang bảo trì.</h4> <a class="btn btn-primary" target="_blank" href="/admin/maintenance-modes">Mở cấu hình danh sách cấp phép IP</a>'.$table->render();

                //Inject pjax for button
                $contentBoxMaintenances .= '
                <script>$("#close-server").on("click",
                    function() {
                        $.ajax({
                            ethod: "get",
                            url: "/admin/api/server/down",
                            success: function () {
                                $.pjax.reload("#pjax-container");
                                toastr.success("Bảo trì máy chủ thành công");
                            },
                            error: function (){
                                toastr.error(t.responseJSON.msg);
                            }
                        });
                });</script>
                <script>$("#open-server").on("click",
                    function() {
                        $.ajax({
                            ethod: "get",
                            url: "/admin/api/server/up",
                            success: function () {
                                $.pjax.reload("#pjax-container");
                                toastr.success("Mở lại máy chủ thành công!");
                            },
                            error: function (t){
                                toastr.success(t.responseJSON.msg);
                            }
                        });
                });</script>
                <script>$("#clear-all-cache").on("click",
                    function() {
                        $.ajax({
                            ethod: "get",
                            url: "/admin/api/clear-all-cache",
                            success: function () {
                                $.pjax.reload("#pjax-container");
                                toastr.success("Xoá toàn bộ cache thành công!");
                            },
                            error: function (t){
                                toastr.success("Có lỗi trong quá trình xoá cache");
                            }
                        });
                });</script>



                ';
                $box2 = new Box('Trạng thái bảo trì', $contentBoxMaintenances);


                /*
                 * BUILD XML Data
                 */


                $box3 = '
                <div id="result_data_section" class="box box-default" style="display: none">
                    <div class="box-header with-border">
                        <h3 class="box-title" id="resultXML_data_section_title">BuildXML Data</h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                            </button>
                            <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
                        </div>
                    </div>
                    <div class="box-body">
                        <p id="result_data_section_data"></p>
                    </div>
                </div>';

                //BuildXMLScript
                $box3 .= '<script type="text/javascript">';
                foreach ($serverList as $server){
                    $box3.=
                        '

                        //Build XML
                        $("#createAllXML_'.$server->ServerID.'").click(function (){
                            toastr.info("Đang tiến hành CreateAllXML");
                            $.ajax({
                                method: "get",
                                url: "/admin/api/build-xml/createallxml/'.$server->ServerID.'",
                                success: function (t) {
                                    $("#resultXML_data_section_title").html("CreateAllXML Server: '.$server->ServerName.'");
                                    $("#result_data_section").show();
                                    $("#result_data_section_data").html(t.msg);
                                },
                                error: function (t){
                                    toastr.error(t.responseJSON.msg);
                                }
                            });
                        });
                        $("#BuildQuestXML_'.$server->ServerID.'").click(function (){
                            toastr.info("Đang tiến hành Build nhiệm vụ");
                            $.ajax({
                                method: "get",
                                url: "/admin/api/build-xml/quest/'.$server->ServerID.'",
                                success: function (t) {
                                    $("#resultXML_data_section_title").html("Build Quest Server: '.$server->ServerName.'");
                                    $("#result_data_section").show();
                                    $("#result_data_section_data").html(t.msg);
                                },
                                error: function (t){
                                    toastr.error(t.responseJSON.msg);
                                }
                            });
                        });
                        $("#BuildActiveXML_'.$server->ServerID.'").click(function (){
                            toastr.info("Đang tiến hành Build Active (GiftCode)");
                            $.ajax({
                                method: "get",
                                url: "/admin/api/build-xml/active/'.$server->ServerID.'",
                                success: function (t) {
                                    $("#resultXML_data_section_title").html("Build Build Active (GiftCode): '.$server->ServerName.'");
                                    $("#result_data_section").show();
                                    $("#result_data_section_data").html(t.msg);
                                },
                                error: function (t){
                                    toastr.error(t.responseJSON.msg);
                                }
                            });
                        });

                        //Maintenance Server Game
                        $("#MaintenanceServer_'.$server->ServerID.'").click(function (){
                            toastr.info("Đang tiến hành Bảo trì server Game '.$server->ServerName.'");
                            $.ajax({
                                method: "get",
                                url: "/admin/api/maintenance/down/'.$server->ServerID.'",
                                success: function (t) {
                                    $.pjax.reload("#pjax-container");
                                    toastr.success(t.msg);
                                    toastr.info("Vui lòng đợi trong 5 phút để quá trình bảo trì hoàn tất");
                                },
                                error: function (t){
                                   toastr.error(t.responseJSON.msg);
                                   $.pjax.reload("#pjax-container");
                                }
                            });
                        });

                        $("#OpenServer_'.$server->ServerID.'").click(function (){
                            toastr.info("Đang tiến hành mở lại server Game '.$server->ServerName.'");
                            $.ajax({
                                method: "get",
                                url: "/admin/api/maintenance/up/'.$server->ServerID.'",
                                success: function (t) {
                                    $.pjax.reload("#pjax-container");
                                    toastr.success(t.msg);
                                },
                                error: function (t){
                                    toastr.error(t.responseJSON.msg);
                                }
                            });
                        });
                        ';
                }
                $box3 .='</script>';

                $row->column(7,$box1);
                $row->column(5,$box2);
                $row->column(7, $box3); //Build XML result
            });
    }
}

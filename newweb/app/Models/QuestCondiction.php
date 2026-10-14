<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class QuestCondiction extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest_Condiction';
    protected $primaryKey = 'ID';
    protected $fillable= ['ID', 'QuestID', 'CondictionID', 'CondictionType', 'CondictionTitle', 'Para1', 'Para2', 'isOpitional'];

    public $timestamps = false;
    public $incrementing = true;
    protected $appends = ['fake'];

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function Quest()
    {
        return $this->belongsTo('App\Models\Quest', 'QuestID', 'ID');
    }

    public function getCondictionTypeText()
    {
        return self::CondictionText($this->CondictionType);
    }

    public static function CondictionText($id = 0)
    {
        $condictionType = [
            102 => 'Tắm suối nước nóng {x} phút',
            100 => 'Trực tuyến game {x} phút',
            1 => 'Đăng nhập game (1)',
            16 => 'Đăng nhập game (16)',
            3 => 'Sử dụng vật phẩm {x} {y} lần',
            4 => 'Trong chiến đấu đánh bại {x} người',
            5 => 'Hoàn thành {x} trận chiến đấu',
            6 => 'Chiến thắng {x} trận chiến đấu',
            9 => 'Cường hoá vật phẩm {x} lên cấp {y}',
            10 => 'Tiêu phí shop',
            11 => 'Dung luyện vật phẩm {x}',
            13 => 'Đích thân hạ NPC {x}',
            15 => 'Thu thập {y}=1 vật phẩm {x}',
            17 => 'Kết hôn',
            18 => 'Guild đạt {x} người, gia nhập G, rèn-két-shop G đạt cấp {y}',
            19 => 'dùng đá {x} để hợp thành thành công',
            20 => 'vào đấu giá, phòng tập,phòng cao thủ, kết bạn , tăng số lượng bạn bè',
            21 => 'Vượt ải {x}',
            22 => 'Tiêu diệt {x} người trong G chiến',
            23 => 'Hoàn thành {x} trận G chiến',
            24 => 'Chiến thắng {x} trận G chiến',
            25 => 'Khảm nạn châu báu bất kì',
            26 => 'Hoàn thành {x} trận vợ chồng',
            27 => 'Vào suối nước nóng',
            28 => 'Vợ chồng thắng {x} trận',
            29 => 'Hoàn thành {x} thành tích',
            30 => 'Tích luỹ {x} tài sản, hoàn thành {y} 2vs2',
            33 => 'Gửi thư cho bạn bè',
            34 => 'Tham gia {x} trận 2vs2',
            35 => 'Bái 1 sư phụ, thu nạp đệ tử',
            36 => 'Sư phụ và đệ tử hoàn thành {x} trận ',
            37 => 'Sư phụ và đệ tử hoàn thành {x} trận',
            38 => 'Đổi {x} xu vào game',
            39 => 'Mặc đồ {x}',
            55 => 'Cấp VIP đạt {y}',
            104 => 'Vượt ải {x} {y} lần',
        ];
        if (empty($id)) {
            return $condictionType;
        }
        return $condictionType[$id];
    }

}

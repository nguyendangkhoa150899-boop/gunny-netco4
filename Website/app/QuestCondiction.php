<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class QuestCondiction extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Quest_Condiction';
    protected $primaryKey = 'CondictionTitle';
    protected $fillable= ['QuestID', 'CondictionID', 'CondictionType', 'CondictionTitle', 'Para1', 'Para2', 'isOpitional'];

    public $timestamps = false;
    public $incrementing = false;
    protected $appends = ['fake'];

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Quest()
    {
        return $this->hasOne('App\Quest', 'ID', 'QuestID');
    }

    public function getCondictionTypeText()
    {
        switch ((int) $this->CondictionType) {
            case 102:
                return 'Tắm suôi nước nóng {x} phút';
            case 100:
                return 'Trực tuyến game {x} phút';
            case 1:
                return 'Đăng nhập game (1)';
            case 16:
                return 'Đăng nhập game (16)';
            case 3:
                return 'Sử dụng vật phẩm bất kì';
            case 4:
                return 'Trong chiến đấu đánh bại {x} người';
            case 5:
                return 'Hoàn thành {x} trận chiến đấu';
            case 6:
                return 'Chiến thắng {x} trận chiến đấu';
            case 9:
                return 'Cường hoá vật phẩm {x} lên cấp {y}';
            case 10:
                return 'Tiêu phí shop';
            case 11:
                return 'Dung luyện vật phẩm {x}';
            case 13:
                return 'Đích thân hạ NPC {x}';
            case 15:
                return 'Thu thập vật phẩm {x}';
            case 17:
                return 'Kết hôn';
            case 18:
                return 'Guild đạt {x} người, gia nhập G, rèn-két-shop đạt cấp {y}';
            case 19:
                return 'dùng đá {x} để hợp thành thành công';
            case 20:
                return 'vào đấu giá, phòng tập, phòng cao thủ, kết bạn, tăng số lượng bạn bè';
            case 21:
                return 'Vượt ải {x}';
            case 22:
                return 'Tiêu diệt {x} người trong G chiến';
            case 23:
                return 'Hoàn thành {x} trận G chiến';
            case 24:
                return 'Chiến thắng {x} trận G chiến';
            case 25:
                return 'Khảm nạn châu báu bất kì';
            case 26:
                return 'Hoàn thành {x} trận vợ chồng';
            case 27:
                return 'Vào suối nước nóng';
            case 28:
                return 'Vợ chồng thắng {x} trận';
            case 29:
                return 'Hoàn thành {x} thành tích';
            case 30:
                return 'Tích luỹ {x} tài sản; hoàn thành {y} 2vs2';
            case 33:
                return 'Gửi thư cho bạn bè';
            case 34:
                return 'Tham gia {x} trận 2vs2';
            case 35:
                return 'Bái 1 sư phụ; thu nạp đệ tử';
            case 36:
                return 'Sư phụ và đệ tử hoàn thành {x} trận ';
            case 37:
                return 'Sư phụ và đệ tử hoàn thành {x} trận';
            case 38:
                return 'Đổi {x} xu vào game';
        }
    }

    /**
     * @param string $primaryKey
     */
    public function setPrimaryKey(string $primaryKey): void
    {
        $this->primaryKey = $primaryKey;
    }

    /**
     * @return string
     */
    public function getPrimaryKey(): string
    {
        return $this->primaryKey;
    }

    public function getFakeAttribute()
    {
        return $this->QuestID.'-'.$this->CondictionID.'-'.$this->CondictionType.'-'.'CondictionTitle'.'-'.$this->Para1.'-'.$this->Para2;
    }

}

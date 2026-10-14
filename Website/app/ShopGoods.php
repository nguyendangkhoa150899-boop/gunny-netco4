<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ShopGoods extends Model
{
    protected $connection = 'sqlsrv_tank';
    public $table = 'Shop_Goods';
    protected $primaryKey = 'TemplateID';
    public $timestamps = false;
//    protected $guarded = ['TemplateID'];
    public $fillable = ['TemplateID', 'Name'];
    // protected $hidden = [];
    // protected $dates = [];

    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Shop()
    {
//        return $this->hasOne('App\Shop','TemplateID','TemplateID');
        return $this->belongsTo('App\Shop', 'TemplateID','TemplateID');
    }

    public function DropItem()
    {
//        return $this->hasOne('App\Shop','TemplateID','TemplateID');
        return $this->belongsTo('App\DropItem', 'ItemId','TemplateID');
    }

    public function convertSex()
    {
        switch ($this->NeedSex)
        {
            case "0":
            case "2":
                return "f";
            case "1":
                return "m";
            default:
                return "s";
        }
    }

    public function ConvertCategoryID()
    {
        switch ($this->CategoryID)
        {
            case "1":
                return "head";
            case "2":
                return "glass";
            case "3":
                return "hair";
            case "4":
                return "eff";
            case "5":
                return "cloth";
            case "6":
                return "face";
            default:
                return "";
        }
    }

    public function getResourceLink()
    {
        $resourceBaseUrl = env('RESOURCE_URL');
        switch ($this->CategoryID)
        {
            case 1: //nón
            case 2: //kính
            case 3: //tóc
            case 4: //mặt
            case 5: //quần áo
            case 6: //mắt
                $str = "/image/equip/" . $this->convertSex() . "/" . $this->ConvertCategoryID() . "/" . $this->Pic . "/icon_1.png";
                break;
            case 7: //vũ khí
            case 64: //what the hell know?
            case 27: //vũ khí đặc biệt (hoàng kim vũ, vũ khí tạm thời các thứ)
                $str = "/image/arm/" . $this->Pic . "/00.png";
                break;
            case 8: //vòng tay
                $str = "/image/equip/armlet/" . $this->Pic . "/icon.png";
                break;
            case 9: //nhẫn
                $str = "/image/equip/ring/" . $this->Pic . "/icon.png";
                break;
            case 12: //đạo cụ nhiệm vụ
                $str = "/image/task/" . $this->Pic . "/icon.png";
                break;
            case 13: //set quần áo
                $str = "/image/equip/" . $this->convertSex() . "/suits/" . $this->Pic . "/icon_1.png";
                break;
            case 14: //dây chuyền
                $str = "/image/equip/necklace/" . $this->Pic . "/icon.png";
                break;
            case 15: //cánh
                $str = "/image/equip/wing/" . $this->Pic . "/icon.png";
                break;
            case 16: //bong bóng
                $str = $this->TemplateID < 200202 ? "/image/specialprop/chatBall/" . $this->Pic . "/icon.png" : "/image/unfrightprop/" . $this->Pic . "/icon.png";
                break;
            case 17: //vũ khí phụ
                $str = "/image/equip/offhand/" . $this->Pic . "/icon.png";
                break;
            case 18: //hộp thẻ
                $str = "/image/cardbox/" . $this->Pic . "/icon.png";
                break;
            case 19: //hỗ trợ? (đá hồi phục)
                $str = "/image/equip/recover/" . $this->Pic . "/icon.png";
                break;
            case 23: //sách tu luyện cc gì á
                $str = "/image/prop/" . $this->Pic . "/icon.png";
                break;
            case 25: //quà tặng
                $str = "/image/gift/" . $this->Pic . "/icon.png";
                break;
            case 26: //thẻ bài
                $str = "/image/card/" . $this->Pic . "/icon.jpg";
                break;
            case 50:
                $str = "/image/petequip/arm/" . $this->Pic . "/icon.png";
                break;
            case 51:
                $str = "/image/petequip/hat/" . $this->Pic . "/icon.png";
                break;
            case 52:
                $str = "/image/petequip/cloth/" . $this->Pic . "/icon.png";
                break;
            case 10: //đạo cụ
            case 11: //đạo cụ
            case 34:
            case 20:
            case 35:
            case 40:
            case 61:
            default:
                $str = "/image/unfrightprop/" . $this->Pic . "/icon.png";
                break;
        }
        return trim($resourceBaseUrl, '/') . $str;
    }

    public function ResourceImageColumn()
    {
        return '<img width="40" height="40" src="'.$this->getResourceLink().'">';
    }

    public function ResourceImageSelectColumn()
    {
        return '<img width="25" height="25" src="'.$this->getResourceLink().'">';

    }

    public function combine4Column()
    {
        if($this->Attack == 0 && $this->Defence == 0 && $this->Agility == 0 && $this->Luck == 0)
            return 'Không có';
        return $this->Attack.'-'.$this->Defence.'-'.$this->Agility.'-'.$this->Luck;
    }

    // for api selection list of operations
    public function apiSelectionDisplay()
    {
        // name + 4 columns + image
        return $this->Name.' - '.$this->combine4Column();
    }

    public function QualityText()
    {
        $qualities = [
            1 => 'thô',
            2 => 'thường',
            3 => 'ưu',
            4 => 'tinh anh',
            5 => 'xuất sắc',
            6 => 'truyền thuyết',
        ];
        return $qualities[$this->Quality];
    }

    public function ResourceImageColumnForCompete($id)
    {

        return '<img class="compete-item" width="40" height="40" data-prosperity='.$id.' src="'.$this->getResourceLink().'">';
    }

    public function ResourceImageColumnForQuest()
    {
        return '<img title="'.$this->Name.'" width="40" height="40" src="'.$this->getResourceLink().'">';
    }
}

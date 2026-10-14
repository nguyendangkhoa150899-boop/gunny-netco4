<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Shop extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    public $table = "Shop";
    protected $primaryKey = 'ID';
    protected $casts = ['TemplateID' => 'integer' ]; //Must call for ShopGoods relationship
    public $fillable = ['ID', 'ShopID', 'GroupID', 'TemplateID', 'BuyType', 'IsContinue', 'IsBind', 'IsVouch', 'Label', 'Beat', 'AUnit', 'APrice1', 'AValue1', 'APrice2', 'AValue2', 'APrice3', 'AValue3', 'BUnit', 'BPrice1', 'BValue1', 'BPrice2', 'BValue2', 'BPrice3', 'BValue3', 'CUnit', 'CPrice1', 'CValue1', 'CPrice2', 'CValue2', 'CPrice3', 'Sort', 'CValue3', 'IsCheap', 'LimitCount', 'StartDate', 'EndDate', 'LimitGrade', 'CanBuy'];
    public $timestamps = false;
    public $incrementing = false;

    protected $guarded = [];
    //Price => Hình thức bán (Xu, HC, LK)
    //Unit => Ngày sử dụng
    //Value => Giá cả (100xu/480HC/60LK)

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function Item()
    {
        return $this->hasOne('App\Models\ShopGoods', 'TemplateID', 'TemplateID')->withDefault();
    }

    public function DepartmentType()
    {
        return $this->hasOne(ShopGoodsShowList::class, 'ShopId', 'ID');
        return $this->hasOneThrough(
            ShopType::class, //destination model
            ShopGoodsShowList::class, //pivot model
            'ShopId', //pivot field that related with this
            'ID', //destination table's field that's related with pivot table
            'ID', //field on this table that's related to pivot table
            'Type' //field on pivot table that's related to destination table
        );
    }

    public function Department()
    {
        if (!empty($this->DepartmentType)) {
            return $this->DepartmentType->DepartmentName();
        }
        return '-';
    }

    public function getPriceText($price, $value)
    {
        switch ((int)$price) {
            case -1:
                return (int)$value.' Xu';
            case 11408:
                return (int)$value.' HC';
            case -4:
                return (int)$value.' LK';
            case -3:
                return (int)$value.' CT'; //công trạng
            case -6:
                return (int)$value.' VMK'; //vàng mê cung
        }
    }

    public function getPriceTextStyle($price, $value)
    {
        switch ((int)$price) {
            case -1:
                return (int)$value.' <span class="badge btn-danger">Xu</span>';
            case 11408:
                return (int)$value.' <span class="badge btn-warning">Huân chương</span>';
            case -4:
                return (int)$value.' <span class="badge btn-primary">Lễ Kim</span>';
            case -3:
                return (int)$value.' <span class="badge btn-primary">Công trạng</span>'; //công trạng
            case -6:
                return (int)$value.' <span class="badge btn-primary">Vàng mê cung</span>'; //vàng mê cung
        }
    }

    public function getAPrice1Type()
    {
        switch ((int) $this->APrice1) {
            case -1:
                return '<span class="badge btn-danger">Xu</span>';
                break;
            case 11408:
                return '<span class="badge btn-warning">Huân chương</span>';
            case -4:
                return '<span class="badge btn-primary">Lễ Kim</span>';
            case -3:
                return '<span class="badge btn-primary">Công trạng</span>';
        }
    }

    public function getAValue1($withStyle = false)
    {
        if((int)$this->AValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        if ($withStyle) {
            return $this->getPriceTextStyle($this->APrice1, $this->AValue1);
        }
        return $this->getPriceText($this->APrice1, $this->AValue1);
    }


     public function getBPrice1Type()
    {
        switch ((int) $this->BPrice1) {
            case -1:
                return '<span class="badge btn-danger">Xu</span>';
            case 11408:
                return '<span class="badge btn-warning">Huân chương</span>';
            case -4:
                return '<span class="badge btn-primary">Lễ Kim</span>';
        }
    }

    public function getBUnit()
    {
        if((int)$this->BUnit == -1){
            return '<span class="badge btn-default">Không có</span>';
        }
        return (int)$this->BUnit.' ngày';
    }

    public function getBValue1($withStyle = false)
    {
        if((int)$this->BValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        if ($withStyle) {
            return $this->getPriceTextStyle($this->BPrice1, $this->BValue1);
        }
        return $this->getPriceText($this->BPrice1, $this->BValue1);
    }

     public function getCPrice1Type()
    {
        switch ((int) $this->CPrice1) {
            case -1:
                return '<span class="badge btn-danger">Xu</span>';
            case 11408:
                return '<span class="badge btn-warning">Huân chương</span>';
            case -4:
                return '<span class="badge btn-primary">Lễ Kim</span>';
        }
    }


    public function getCUnit()
    {
        if((int)$this->CUnit == 0){
            return 'Vĩnh viễn';
        }
        if((int)$this->CUnit == -1){
            return '<span class="badge btn-default">Không có</span>';
        }
        return (int)$this->CUnit.' ngày';
    }

    public function getCValue1($withStyle = false)
    {
        if((int)$this->CValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        if ($withStyle) {
            return $this->getPriceTextStyle($this->CPrice1, $this->CValue1);
        }
        return $this->getPriceText($this->CPrice1, $this->CValue1);
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public static function ShopIDTypes()
    {
        return [
            1 => 'Cửa hàng',

        ];
    }

    public function getStartDateAttribute($value)
    {
        return date('Y-m-d', strtotime($value));
    }

    public function getEndDateAttribute($value)
    {
        return date('Y-m-d', strtotime($value));
    }

    public static function apiSelectionDisplayFields()
    {
        return [
            'ShopID' => 'int',
            'BuyType' => 'int',
            'AUnit' => 'int',
            'APrice1' => 'int',
            'AValue1' => 'int',
            'BUnit' => 'int',
            'BPrice1' => 'int',
            'BValue1' => 'int',
            'CUnit' => 'int',
            'CPrice1' => 'int',
            'CValue1' => 'int',
            'StartDate' => 'string',
            'EndDate' => 'string',
        ];
    }
    public function apiSelectionDisplay()
    {
        //$attrs = self::apiSelectionDisplayFields();
        $str = $this->Item->Name . ' - ';
        if (intval($this->Label) == 7) {
            $str .= 'Shop miễn phí';
        } else {
            $str .= 'Giá ';
            $str .= $this->getAValue1(true) . '/' . $this->getBValue1(true) . '/' . $this->getCValue1(true);
        }
        $str .= ' - Từ '.$this->StartDate.' -> '.$this->EndDate;
        return $str;
    }
}

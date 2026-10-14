<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Shop extends Model
{
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
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Item()
    {
        return $this->hasOne('App\ShopGoods', 'TemplateID', 'TemplateID')->withDefault();
    }

    public function ShopList()
    {
        return $this->belongsTo('App\Shop','ShopId','ID');
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
        }
    }

    public function getAValue1()
    {
        if((int)$this->AValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        switch ((int) $this->APrice1) {
            case -1:
                return (int)$this->AValue1.' Xu';
            case 11408:
                return (int)$this->AValue1.' HC';
            case -4:
                return (int)$this->AValue1.' LK';
        }
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

    public function getBValue1()
    {
        if((int)$this->BValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        switch ((int) $this->BPrice1) {
            case -1:
                return (int)$this->BValue1.' Xu';
            case 11408:
                return (int)$this->BValue1.' HC';
            case -4:
                return (int)$this->BValue1.' LK';
        }
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

    public function getCValue1()
    {
        if((int)$this->CValue1 == 0){
            return '<span class="badge btn-default">Không có</span>';
        }
        switch ((int) $this->CPrice1) {
            case -1:
                return (int)$this->CValue1.' Xu';
            case 11408:
                return (int)$this->CValue1.' HC';
            case -4:
                return (int)$this->CValue1.' LK';
        }
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }
}

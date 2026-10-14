<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ShopGoodsShowList extends Model
{
    protected $connection = 'sqlsrv_tank';
    public $table = 'ShopGoodsShowList';
    protected $primaryKey = 'Type';
    protected $casts = ['ShopId' => 'decimal:1'];
    public $fillable = ['Type', 'ShopId'];
    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function Shop()
    {
        return $this->hasOne('App\Shop','ID','ShopId')->withDefault();
    }

    public function getTypeShop()
    {
        switch ($this->Type){
            case 1:
                return 'Xu - Mới (Nam)';
            case 2:
                return 'Xu - Mới (Nữ)';
            case 3:
                return 'Xu - Ưu đãi (Nam)';
            case 4:
                return 'Xu - Ưu đãi (Nữ)';
            case 5:
                return 'Xu - Vũ khí (Nam)';
            case 6:
                return 'Xu - Vũ khí (Nữ)';
            case 7:
                return 'Xu - Quần áo (Nam)';
            case 8:
                return 'Xu - Quần áo (Nữ)';
            case 9:
                return 'Xu - Nón (Nam)';
            case 10:
                return 'Xu - Nón (Nữ)';
            case 11:
                return 'Xu - Kính (Nam)';
            case 12:
                return 'Xu - Kính (Nữ)';
            case 13:
                return 'Xu - Trang sức (Nam)';
            case 14:
                return 'Xu - Trang sức (Nữ)';
            case 15:
                return 'Xu - Set quần áo (Nam)';
            case 16:
                return 'Xu - Set quần áo (Nữ)';
            case 17:
                return 'Xu - Tóc (Nam)';
            case 18:
                return 'Xu - Tóc (Nữ)';
            case 19:
                return 'Xu - Cánh (Nam)';
            case 20:
                return 'Xu - Cánh (Nữ)';
            case 21:
                return 'Xu - Mắt (Nam)';
            case 22:
                return 'Xu - Mắt (Nữ)';
            case 23:
                return 'Xu - Mặt (Nam)';
            case 24:
                return 'Xu - Mặt (Nữ)';
            case 25:
                return 'Xu - Đạo cụ chức năng (Nam)';
            case 26:
                return 'Xu - Đạo cụ chức năng (Nữ)';
            case 27:
                return 'Xu - Bong bóng (Nam)';
            case 28:
                return 'Xu - Bong bóng (Nữ)';
            case 29:
                return 'Lễ Kim - Tất cả (Nam)';
            case 30:
                return 'Lễ Kim - Tất cả (Nữ)';
            case 31:
                return 'Lễ Kim - Trang phục (Nam)';
            case 32:
                return 'Lễ Kim - Trang phục (Nữ)';
            case 33:
                return 'Lễ kim - Vũ khí (Nam)';
            case 34:
                return 'Lễ kim - Vũ khí (Nữ)';
            case 35:
                return 'Lễ kim - Làm đẹp (Nam)';
            case 36:
                return 'Lễ kim - Làm đẹp (Nữ)';
            case 37:
                return 'Xu - Đạo cụ (Nam)';
            case 38:
                return 'Xu - Đạo cụ (Nữ)';
            case 39:
                return 'Huân chương - Tất cả (Nam)';
            case 40:
                return 'Huân chương - Tất cả (Nữ)';
            case 41:
                return 'Huân chương - Trang phục (Nam)';
            case 42:
                return 'Huân chương - Trang phục (Nữ)';
            case 43:
                return 'Huân chương - Vũ khí (Nam)';
            case 44:
                return 'Huân chương - Vũ khí (Nữ)';
            case 45:
                return 'Huân chương - Làm đẹp (Nam)';
            case 46:
                return 'Huân chương - Làm đẹp (Nữ)';
            case 47:
                return 'Huân chương - Đạo cụ (Nam)';
            case 48:
                return 'Huân chương - Đạo cụ (Nữ)';
            case 49:
                return 'RECHARGE';
            case 63:
                return 'Xu - HotSale (Nam)';
            case 64:
                return 'Xu - HotSale (Nữ)';
            case 65:
                return 'Xu - Nhận miễn phí (Nam)';
            case 66:
                return 'Xu - Nhận miễn phí (Nữ)';
            case 67:
                return 'Xu - Mua nhiều (Nam)';
            case 68:
                return 'Xu - Mua nhiều (Nữ)';
            default:
                return 'Không xác định ->'. $this->Type;
        }
    }
}

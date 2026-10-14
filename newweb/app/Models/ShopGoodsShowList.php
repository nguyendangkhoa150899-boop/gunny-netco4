<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class ShopGoodsShowList extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';

    protected $table = 'ShopGoodsShowList';
    protected $primaryKey = 'ID';
    public $timestamps = false;
    protected $fillable = ['Type', 'ShopId'];
    public $incrementing = true;

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public static function ShopDepartmentName($type = 0)
    {
        $deps = [
            63 => 'Giới thiệu > Hot (Nam)',
            64 => 'Giới thiệu > Hot (Nữ)',
            1 => 'Giới thiệu > Mới (Nam)',
            2 => 'Giới thiệu > Mới (Nữ)',
            3 => 'Giới thiệu > Ưu đãi (Nam)',
            4 => 'Giới thiệu > Ưu đãi (Nữ)',
            5 => 'Trang bị > Vũ khí (Nam)',
            6 => 'Trang bị > Vũ khí (Nữ)',
            7 => 'Trang bị > Áo (Nam)',
            8 => 'Trang bị > Áo (Nữ)',
            9 => 'Trang bị > Nón (Nam)',
            10 => 'Trang bị > Nón (Nữ)',
            11 => 'Trang bị > Kính (Nam)',
            12 => 'Trang bị > Kính (Nữ)',
            13 => 'Trang bị > Trang sức (Nam)',
            14 => 'Trang bị > Trang sức (Nữ)',
            15 => 'Làm đẹp > Set quần áo (Nam)',
            16 => 'Làm đẹp > Set quần áo (Nữ)',
            17 => 'Làm đẹp > Tóc (Nam)',
            18 => 'Làm đẹp > Tóc (Nữ)',
            19 => 'Làm đẹp > Cánh (Nam)',
            20 => 'Làm đẹp > Cánh (Nữ)',
            21 => 'Làm đẹp > Mắt (Nam)',
            22 => 'Làm đẹp > Mắt (Nữ)',
            23 => 'Làm đẹp > Mặt (Nam)',
            24 => 'Làm đẹp > Mặt (Nữ)',
            25 => 'Đạo cụ > Chức năng (Nam)',
            26 => 'Đạo cụ > Chức năng (Nữ)',
            27 => 'Đạo cụ > Đặc biệt (Nam)',
            28 => 'Đạo cụ > Đặc biệt (Nữ)',
            29 => 'Đổi > Lễ kim > Tất cả (Nam)',
            30 => 'Đổi > Lễ kim > Tất cả (Nữ)',
            31 => 'Đổi > Lễ kim > Trang phục (Nam)',
            32 => 'Đổi > Lễ kim > Trang phục (Nữ)',
            33 => 'Đổi > Lễ kim > Vũ khí (Nam)',
            34 => 'Đổi > Lễ kim > Vũ khí (Nữ)',
            35 => 'Đổi > Lễ kim > Làm đẹp (Nam)',
            36 => 'Đổi > Lễ kim > Làm đẹp (Nữ)',
            37 => 'Đổi > Lễ kim > Đạo cụ (Nam)',
            38 => 'Đổi > Lễ kim > Đạo cụ (Nữ)',
            39 => 'Đổi > Huân chương > Tất cả (Nam)',
            40 => 'Đổi > Huân chương > Tất cả (Nữ)',
            41 => 'Đổi > Huân chương > Trang phục (Nam)',
            42 => 'Đổi > Huân chương > Trang phục (Nữ)',
            43 => 'Đổi > Huân chương > Vũ khí (Nam)',
            44 => 'Đổi > Huân chương > Vũ khí (Nữ)',
            45 => 'Đổi > Huân chương > Làm đẹp (Nam)',
            46 => 'Đổi > Huân chương > Làm đẹp (Nữ)',
            47 => 'Đổi > Huân chương > Đạo cụ (Nam)',
            48 => 'Đổi > Huân chương > Đạo cụ (Nữ)',
            49 => 'RECHARGE',
            50 => 'Shop Guild cấp 1',
            51 => 'Shop Guild cấp 2',
            52 => 'Shop Guild cấp 3',
            53 => 'Shop Guild cấp 4',
            54 => 'Shop Guild cấp 5',
            55 => 'CONCESSIONS',
            56 => 'Đạo cụ chiến đấu',
            57 => 'HOT_GOODS',
            58 => 'Tặng quà -> Hoa',
            59 => 'Tặng quà -> Đồ ăn',
            60 => 'Tặng quà -> Đồ chơi',
            61 => 'Tặng quà -> Hiếm',
            62 => 'Tặng quà -> Lễ tết',
            71 => 'Tặng quà -> Cưới',
            65 => 'Nhận miễn phí (Nam)',
            66 => 'Nhận miễn phí (Nữ)',
            67 => 'Mua nhiều (Nam)',
            68 => 'Mua nhiều (Nữ)',
            69 => 'M_PRAISE_RANKING',
            70 => 'F_PRAISE_RANKING',
            88 => 'Nông trại > Hạt giống',
            89 => 'FARM_MANURE_TYPE',
            92 => 'Nông trại > Tích điểm',
            72 => 'LITTLEGAME_AWARD_TYPE',
        ];
        if (empty($type)) {
            return $deps;
        }
        return $deps[$type];
    }


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function ShopItem()
    {
        return $this->belongsTo(Shop::class, 'ShopId', 'ID')->withDefault();
    }

    public function Item()
    {
        return $this->ShopItem->Item;
    }

    public function ResourceImageColumn()
    {
        return $this->ShopItem->ResourceImageColumn();
    }

    public function ItemName()
    {
        return $this->Item()->Name;
    }

    public function Department()
    {
        return $this->hasOne(ShopType::class, 'ID', 'Type');
    }

    public function DepartmentName()
    {
        if (!empty($this->Department)) {
            return $this->Department->Name;
        }
    }

    /*
    |--------------------------------------------------------------------------
    | SCOPES
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}

<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('permissions')->insert([
            'name' => 'addCoin',
            'guard_name' => 'web',
        ]);
        DB::table('permissions')->insert([
            'name' => 'roleManagement',
            'guard_name' => 'web',
        ]);
        DB::table('permissions')->insert([
            'name' => 'permissionManagement',
            'guard_name' => 'web',
        ]);
        DB::table('permissions')->insert([
            'name' => 'memberManagement',
            'guard_name' => 'web',
        ]);
        DB::table('permissions')->insert([
            'name' => 'gameManagement',
            'guard_name' => 'web',
        ]);
        DB::table('permissions')->insert([
            'name' => 'SendGoods',
            'guard_name' => 'web',
        ]);
    }
}

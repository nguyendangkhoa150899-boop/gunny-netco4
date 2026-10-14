<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('roles')->insert([
            'name' => 'Moderators',
            'guard_name' => 'web',
        ]);
        DB::table('roles')->insert([
            'name' => 'Administrators',
            'guard_name' => 'web',
        ]);
        DB::table('roles')->insert([
            'name' => 'System Administrators',
            'guard_name' => 'web',
        ]);
        DB::table('roles')->insert([
            'name' => 'Game Masters',
            'guard_name' => 'web',
        ]);
    }
}

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAdminRelateTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

//        Schema::connection('sqlsrv')->create('admin_coin_logs', function (Blueprint $table) {
//            $table->bigIncrements('id');
//            $table->string('MemberUserName');
//            $table->string('OwnerActionId');
//            $table->integer('Bonus');
//            $table->integer('Value');
//            $table->string('Description')->nullable();
//            $table->timestamps();
//        });

        Schema::connection('sqlsrv')->create('admin_client_configs', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('key');
            $table->string('value');
            $table->string('description')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('admin_coin_logs');
        Schema::dropIfExists('admin_client_configs');
    }
}

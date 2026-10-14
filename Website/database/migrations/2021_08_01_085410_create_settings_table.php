<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSettingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
//        Schema::connection('sqlsrv_mem')->create('Settings', function (Blueprint $table) {
//            $table->increments('ID');
//            $table->string('Key')->unique();
//            $table->string('Name');
//            $table->string('Description')->nullable();
//            $table->text('Value')->nullable();
//            $table->text('Field');
//            $table->tinyInteger('Active');
//            $table->timestamps();
//        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('settings');
    }
}

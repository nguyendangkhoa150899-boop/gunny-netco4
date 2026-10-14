<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVerifyEmailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
//        Schema::connection('sqlsrv_mem')->create('Verify_Email', function (Blueprint $table) {
//            $table->string('Email')->index();
//            $table->string('Token');
//            $table->tinyInteger('IsActivated')->default(0);
//            $table->timestamp('CreatedAt')->nullable();
//        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('Verify_Email');
    }
}

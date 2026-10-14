<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEventCompeteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection('sqlsrv')->create('event_compete', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('category_event_id');
//            $table->foreign('category_event_id')->references('id')->on('category_event_compete');
            $table->unsignedBigInteger('event_type_id');
//            $table->foreign('event_type_id')->references('id')->on('event_type_compete');
            $table->string('event_name');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('event_compete');
    }
}

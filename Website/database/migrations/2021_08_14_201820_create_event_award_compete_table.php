<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEventAwardCompeteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection('sqlsrv')->create('event_award_compete', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('event_compete_id');
//            $table->foreign('event_compete_id')->references('id')->on('event_compete');
            $table->integer('rank')->unsigned();
            $table->string('item_id');
            $table->integer('amount');
            $table->integer('date')->nullable();
            $table->integer('strengthen')->default(0);
            $table->string('composes')->nullable(); //att-def-agi-luck
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
        Schema::dropIfExists('event_award_compete');
    }
}

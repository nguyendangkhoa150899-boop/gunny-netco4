<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddSomeButtonFunctionsToQuestTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection('sqlsrv_tank')->table('Quest', function (Blueprint $table) {
            $table->boolean('CanDoubleAward')->default(false);
            $table->integer('DoubleAwardPrice')->default(0);
            $table->boolean('CanFinishHalf')->default(false);
            $table->integer('FinishHalfPrice')->default(0);
            $table->boolean('CanFinishNow')->default(false);
            $table->integer('FinishNowPrice')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::connection('sqlsrv_tank')->table('Quest', function (Blueprint $table) {
            $table->dropColumn([
                'CanDoubleAward',
                'DoubleAwardPrice',
                'CanFinishHalf',
                'FinishHalfPrice',
                'CanFinishNow',
                'FinishNowPrice',
            ]);
        });
    }
}

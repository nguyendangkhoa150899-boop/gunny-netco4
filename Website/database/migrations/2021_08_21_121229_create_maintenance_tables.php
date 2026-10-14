<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMaintenanceTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection('sqlsrv')->create('maintenance_whitelist_tables', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('mode');
            $table->string('ip_whitelist');
            $table->string('owner_ip')->nullable();
            $table->string('ip_real_headers_param')->default('x-real-ip')->nullable();
            $table->timestamps();
        });

        Schema::connection('sqlsrv')->create('maintenance_webhook_discord_tables', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('webhook_url');
            $table->integer('is_active')->default(0);
//            $table->string('title')->nullable();
//            $table->string('content')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('maintenance_whitelist_tables');
        Schema::dropIfExists('maintenance_webhook_discord_tables');
    }
}

<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\OnlineReport;

class OnlineUsers extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'onlineusers';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $count = DB::connection('sqlsrv_tank41')
            ->table('Sys_Users_Detail')
            ->where('State', 1)
            ->count();
        if (!empty($f)) {
            $count = $f->count;
        }
        $onlineReport = new OnlineReport();
        $onlineReport->online = $count;
        $onlineReport->save();
    }
}

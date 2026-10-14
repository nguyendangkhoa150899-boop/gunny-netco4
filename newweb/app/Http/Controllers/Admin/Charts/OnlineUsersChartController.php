<?php

namespace App\Http\Controllers\Admin\Charts;

use App\Models\OnlineReport;
use Backpack\CRUD\app\Http\Controllers\ChartController;
use ConsoleTVs\Charts\Classes\Highcharts\Chart;

/**
 * Class OnlineUsersChartController
 * @package App\Http\Controllers\Admin\Charts
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class OnlineUsersChartController extends ChartController
{
    public function setup()
    {
        $this->chart = new Chart();

        // RECOMMENDED. Set URL that the ChartJS library should call, to get its data using AJAX.
        $this->chart->load(backpack_url('charts/online-users'));

        $this->chart->type('spline');
        $this->chart->options = [
            'time' => [
                'timezoneOffset' => -420
            ],
            'title' => [
                'text' => 'Online Users 24h',
                'align' => 'left'
            ],
            'plotOptions' => [
                'spline' => [
                    'lineWidth' => 2,
                    'states' => [
                        'hover' => [
                            'lineWidth' => 3
                        ]
                    ],
                    'marker' => [
                        'enable' => false,
                    ],
                    'pointInterval' => 300000, //5 minute
                    'pointStart' => strtotime('-1 day') * 1000
                ]
            ],
            'xAxis' => [
                'type' => 'datetime'
            ],
        ];
        // OPTIONAL
        // $this->chart->minimalist(false);
         $this->chart->displayLegend(false);
         $this->chart->label('');
    }

    /**
     * Respond to AJAX calls with all the chart data points.
     *
     * @return json
     */
     public function data()
     {
         $online_report = OnlineReport::where('created_at', '>=', date('Y-m-d H:i:s', strtotime('-1 day')))->get();

         $data = [];
         foreach ($online_report as $item) {
             $data[] = intval($item->online);
         }

         $this->chart->dataset('Onlines', 'spline', $data);
     }
}

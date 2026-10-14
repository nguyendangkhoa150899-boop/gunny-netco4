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
class RevenueChartController extends ChartController
{
    public function setup()
    {
        $this->chart = new Chart();

        // RECOMMENDED. Set URL that the ChartJS library should call, to get its data using AJAX.
        $this->chart->load(backpack_url('charts/revenue'));

        $this->chart->type('column');
        $this->chart->options = [
            'title' => [
                'text' => 'Thống kê doanh thu',
                'align' => 'left'
            ],
            'plotOptions' => [
                'column' => [
                    'pointPadding' => 0.2,
                    'borderWidth' => 0,
                ]
            ],
            'xAxis' => [
                'categories' => [
                    'Thẻ cào',
                    'Momo',
                    'Bank',
                ]
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

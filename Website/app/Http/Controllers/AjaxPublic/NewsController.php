<?php

namespace App\Http\Controllers\AjaxPublic;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\News;
use Illuminate\Support\Facades\DB;

class NewsController extends Controller
{
//    public function getPublicNews(Request $request)
//    {
//        $type = $request->input('type');
//        if(!$type || $type <= 0 || $type > 3)
//            $news = News::orderBy('NewsID', 'desc')->paginate(2);
//        else
//            $news = News::orderBy('NewsID', 'desc')->where('Type', $type)->paginate(2);
//        return response()->json($news);
//    }

    public function getPublicNews(Request $request)
    {
        if($request->ajax()){
            $type = (int) $request->input('type');
            if(!$type || $type <= 0 || $type > 3)
                $newses = News::orderBy('NewsID', 'desc')->paginate(5);
            else
                $newses = News::orderBy('NewsID', 'desc')->where('Type', $type)->paginate(5);

            $returnNews = '';
            foreach ($newses as $news) {
                switch ((int) $news->Type) {
                    case 1:
                        $typeBadge = "TB";
                        $color = "red";
                        break;
                    case 2:
                        $typeBadge = "TT";
                        $color = "green";
                        break;
                    case 3:
                        $typeBadge = "SK";
                        $color = "orange";
                        break;
                }
                $linkNew = route('view-news-by-id').'?id='.$news->NewsID;
                $returnNews .= '<li><a href="'.$linkNew.'"> <span class="tag '.$color.'">'.$typeBadge.'</span> '.$news->Title.'</a></li>';
            }

            return $returnNews;
        }
        return redirect(route('home'));
    }

}

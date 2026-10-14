<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\News;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    public function showNewsById(Request $request)
    {
        $news = News::findOrfail($request->input('id'));
        return view('client.news.index',compact('news'));
    }
}

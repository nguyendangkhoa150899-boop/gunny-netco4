<?php


namespace App\Http\Controllers;


use App\Models\Article;
use Illuminate\Support\Facades\Cache;

class NewsController extends Controller
{
    public function index($slug)
    {
        if (empty($slug)) {
            return redirect('/');
        }
        $articles = Cache::rememberForever('news-page-articles', function () {
            return \Backpack\NewsCRUD\app\Models\Article::where('status', 'PUBLISHED')
                ->orderBy('created_at', 'desc')
                ->take(7)
                ->get();
        });
        $news = Cache::rememberForever('article-by-slug-'.$slug, function () use ($slug) {
            return Article::where('slug', $slug)->first();
        });
        if (empty($news)) {
            abort(404);
        }
        return view('news', ['news' => $news, 'articles' => $articles]);
    }
}

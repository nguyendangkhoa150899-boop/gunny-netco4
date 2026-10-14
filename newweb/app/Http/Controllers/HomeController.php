<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Player;
use App\Member;
use App\Models\TopRacing;
use App\Models\TopRacingAward;
use App\Models\TopRacingEvent;
use Illuminate\Support\Facades\Cache;

class HomeController extends Controller
{
    const CACHE_REMEMBER_SECONDS = 3600; //1 hour

    public function index()
    {
        //unset session for security reason
        $session_to_be_unset = [
            '2fa_member_id',
            'forgotpass_member_id',
            'forgotpass_member_id_valid'
        ];
        foreach ($session_to_be_unset as $s) {
            $this->unsetSession($s);
        }

        $articles = Cache::rememberForever('homepage-articles', function () {
            return \Backpack\NewsCRUD\app\Models\Article::where('status', 'PUBLISHED')
                ->orderBy('created_at', 'desc')
                ->take(4)
                ->get();
        });

        $toplc = Cache::remember('homepage-top-fight-power', self::CACHE_REMEMBER_SECONDS, function () {
            return Player::select('NickName','FightPower')
                ->orderBy('FightPower', 'desc')
                ->take(10)
                ->get();
        });

        $toponl = Cache::remember('homepage-top-online', self::CACHE_REMEMBER_SECONDS, function () {
            return Player::select('NickName', 'Onlinetime')
                ->orderBy('Onlinetime', 'desc')
                ->take(10)
                ->get();
        });

        $topgrade = Cache::remember('homepage-top-grade', self::CACHE_REMEMBER_SECONDS, function () {
            return Player::select('NickName', 'Grade')
                ->orderBy('Grade', 'desc')
                ->take(10)
                ->get();
        });

        $topwin = Cache::remember('homepage-top-win', self::CACHE_REMEMBER_SECONDS, function () {
            return Player::select('NickName', 'Win')
                ->orderBy('Win', 'desc')
                ->take(10)
                ->get();
        });

        $m = new Member();
        $loggedIn = $m->isLoggedIn();

        $event = Cache::rememberForever('homepage-event', function () {
            $events = TopRacingEvent::currentPopingUpEvents();
            if (!empty($events) && $events->count()) {
                $event = $events->last();
            } else {
                $event = null;
            }
            return $event;
        });

        return view('home', [
            'toplc' => $toplc,
            'toponl' => $toponl,
            'topgrade' => $topgrade,
            'topwin' => $topwin,
            'loggedIn' => $loggedIn,
            'articles' => $articles,
            'event' => $event
        ]);
    }

    public function topRacing($slug)
    {
        if (empty($slug)) {
            return redirect('/');
        }

        $event = Cache::rememberForever('event-'.$slug, function () use ($slug) {
            return TopRacingEvent::where('slug', $slug)->first();
        });
        if (empty($event)) {
            abort('404');
        }

        $topRacing = Cache::rememberForever('top-racing-by-event-'.$event->id, function () use ($event) {
            return TopRacing::where('event_id', $event->id)->where('show', 1)->get();
        });
        $topRacingByRank = [];
        foreach ($topRacing as $top) {
            $_top = [
                'name' => $top->name,
                'id' => $top->id,
                'awards' => []
            ];

            $awards = Cache::rememberForever('top-racing-awards-by-top-'.$top->id, function () use ($top) {
                return TopRacingAward::where('top_id', $top->id)
                    ->where('enabled', 1)
                    ->orderBy('rank')
                    ->orderBy('stt')
                    //->with('Item')
                    ->get();
            });
            if (!empty($awards) && $awards->count()) {
                foreach ($awards as $award) {
                    if (!isset($_top['awards'][$award->rank])) {
                        $_top['awards'][$award->rank] = [];
                    }

                    //handle cache for item
                    $award = Cache::rememberForever('award-'.$award->id, function () use ($award) {
                        $award->load('Item');
                        $award->Item->load('Category');
                        return $award;
                    });
                    $_top['awards'][$award->rank][] = $award;
                }
            }
            $topRacingByRank[] = $_top;
        }
        return view('top', ['event' => $event, 'topRacing' => $topRacingByRank]);
    }

}

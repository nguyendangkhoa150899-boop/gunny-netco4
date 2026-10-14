<?php


namespace App\Http\Controllers\Admin\Api;


use App\Http\Requests\SendItemRequest;
use App\Models\Player;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class SendItemController extends Controller
{
    public function index(SendItemRequest $request)
    {
        $number_of_items = $request->number_of_items;
        $title = $request->mail_title;
        $content = $request->mail_content;
        $gold = $request->gold;
        $money = $request->money;
        $items = $request->items;
        $number_of_mail = floor(count($items) / 5) + 1;
        $baseurl = trim(env('REQUEST_URL'), '/').'/SendMailAndItem.aspx';
        $uri = '?title='.urlencode($title).'&content='.urlencode($content);
        $error = [];
        $players = $request->players;
        if (in_array(-9, $players)) {
            //all server
            $players = Player::select(['UserID'])->pluck('UserID');
        } else if (in_array(-10, $players)) {
            $_players = Player::select(['UserID'])->where('State', 1)->pluck('UserID');
            $players = array_merge($players, $_players);
        }
        foreach ($players as $player_id) {
            $player = Player::select(['UserID', 'NickName'])->where('UserID', $player_id)->first();
            if (empty($player)) {
                continue;
            }
            $url = $baseurl.$uri.'&user_id='.$player_id;
            for ($mail_num = 0; $mail_num < $number_of_mail; $mail_num++) {
                $_uri = $url;
                if ($mail_num == 0) {
                    $_uri .= '&gold='.$gold.'&money='.$money;
                } else {
                    $_uri .= '&gold=0&money=0';
                }
                $_uri .= '&str=';
                for ($item_num = max($mail_num * 5, 0); $item_num < min(($mail_num+1) * 5, count($items)); $item_num++) {
                    $item = $items[$item_num];
                    if (empty($item['id'])) {
                        continue;
                    }
                    if (is_array($item['id'])) {
                        $item['id'] = $item['id'][0];
                    }
                    $item_param = [
                        $item['id'],
                        max(intval($item['count']), 1),
                        intval($item['date']),
                        intval($item['strength']),
                        intval($item['attack']),
                        intval($item['defend']),
                        intval($item['agility']),
                        intval($item['luck']),
                        intval($item['bind']),
                    ];
                    $_uri .= implode(',', $item_param).'|';
                }
                $result = file_get_contents($_uri);
                if ($result !== "1") {
                    $error[] = "Lỗi nhân vật ".$player->NickName;
                }
            }
        }
        if (!empty($error)) {
            echo json_encode(['success' => false, 'message' => implode('<br>', $error)]);
            return;
        }

        echo json_encode(['success' => true, 'message' => '']);
        return;
    }
}
